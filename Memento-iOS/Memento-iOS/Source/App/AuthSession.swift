import Foundation
import Combine
import AuthenticationServices
import Firebase
import FirebaseAuth
import FirebaseMessaging
import GoogleSignIn

final class AuthSession: ObservableObject {
    static let shared = AuthSession()

    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let keychain = TokenKeychainManager.shared

    private init() {
        isLoggedIn = keychain.hasValidToken()
    }

    // MARK: - Token Accessors

    var hasValidAccessToken: Bool {
        keychain.hasValidToken()
    }

    func currentAccessToken() -> String? {
        return try? keychain.getAccessToken()
    }

    // MARK: - Mutating APIs

    func setTokens(accessToken: String, refreshToken: String) {
        let normalizedAccess = accessToken.replacingOccurrences(of: "Bearer ", with: "")
        let normalizedRefresh = refreshToken.replacingOccurrences(of: "Bearer ", with: "")
        do {
            try keychain.saveAccessToken(normalizedAccess)
            try keychain.saveRefreshToken(normalizedRefresh)
            isLoggedIn = keychain.hasValidToken()
        } catch {
            print("[ERROR] Failed to persist tokens: \(error)")
            isLoggedIn = false
        }
    }

    func clear() {
        do {
            try keychain.clearTokens()
        } catch {
            print("[ERROR] Failed to clear tokens: \(error)")
        }
        isLoggedIn = false
    }
}

// MARK: - Sign In Flows

extension AuthSession {

    func signInWithGoogle() {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true

            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                    Task { @MainActor in
                        guard let self = self else { return }
                        await self.authenticateGoogleUser(for: user, with: error)
                    }
                }
            } else {
                guard let clientID = FirebaseApp.app()?.options.clientID else {
                    self.handleError(nil, defaultMessage: "Google 클라이언트 ID 누락")
                    return
                }

                let configuration = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = configuration

                guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
                    self.handleError(nil, defaultMessage: "루트 뷰 컨트롤러를 찾을 수 없습니다.")
                    return
                }

                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
                    Task { @MainActor in
                        guard let self = self else { return }
                        if let result = result {
                            await self.authenticateGoogleUser(for: result.user, with: error)
                        } else {
                            self.handleError(error, defaultMessage: "Google 로그인 실패")
                        }
                    }
                }
            }
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            clear()
            print("Google 로그아웃 성공")
        } catch {
            print("Google 로그아웃 실패: \(error.localizedDescription)")
        }
    }

    func prepareAppleSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
    }

    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }

            switch result {
            case .success(let authorization):
                await processAppleAuthorization(authorization)
            case .failure(let error):
                handleError(error, defaultMessage: "Apple 로그인 실패")
            }
        }
    }

    private func handleError(_ error: Error?, defaultMessage: String) {
        self.errorMessage = error?.localizedDescription ?? defaultMessage
        self.isLoading = false
    }
}

// MARK: - Network Integration

extension AuthSession {

    private func authenticateGoogleUser(for user: GIDGoogleUser?, with error: Error?) async {
        defer { isLoading = false }

        if let error = error {
            handleError(error, defaultMessage: "Google 로그인 실패")
            return
        }

        guard let idToken = user?.idToken?.tokenString else {
            handleError(nil, defaultMessage: "Google 사용자 토큰 누락")
            return
        }

        await requestLogin(provider: "GOOGLE", idToken: idToken)
    }

    private func processAppleAuthorization(_ authorization: ASAuthorization) async {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = appleIDCredential.identityToken,
              let idTokenString = String(data: idTokenData, encoding: .utf8) else {
            handleError(nil, defaultMessage: "Apple 사용자 인증 정보 누락")
            return
        }

        await requestLogin(provider: "APPLE", idToken: idTokenString)
    }

    private func requestLogin(provider: String, idToken: String) async {
        do {
            let fcmToken = try await Messaging.messaging().token()
            let timeZoneOffset = Self.currentTimeZoneOffset()

            let memberService = MemberAPIService()
            memberService.socialLogin(
                provider: provider,
                idToken: idToken,
                timeZoneOffset: timeZoneOffset,
                fcmToken: fcmToken
            ) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    if let data = response?.data {
                        self.setTokens(accessToken: data.accessToken, refreshToken: data.refreshToken)
                    }
                case .unAuthorized:
                    self.handleError(nil, defaultMessage: "인증 실패. 다시 로그인하세요.")
                default:
                    self.handleError(nil, defaultMessage: "서버 오류가 발생했습니다.")
                }
            }

        } catch {
            handleError(error, defaultMessage: "FCM 토큰을 가져올 수 없습니다.")
        }
    }

    private static func currentTimeZoneOffset() -> String {
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds / 3600
        let minutes = abs(seconds / 60 % 60)
        return String(format: "%+03d:%02d", hours, minutes)
    }
}
/*
private extension AppState {

    /// JWT 토큰의 Payload를 디코딩하여 콘솔에 디버깅 출력합니다.
    ///
    /// 이 함수는 전달된 JWT 문자열을 파싱하여 payload 부분(base64 인코딩된 JSON)을 추출하고,
    /// 이를 디코딩하여 Payload 내부의 key-value 구조를 콘솔에 출력합니다.
    ///
    /// `exp` 필드가 존재할 경우, 해당 만료 시간을 Date로 변환하여 사람이 읽을 수 있는 형식으로 함께 출력합니다.
    ///
    /// - Parameter token: JWT 형식의 액세스 토큰 문자열 (`header.payload.signature` 형식)
    ///
    /// - Note:
    ///    - JWT는 3개의 base64 인코딩된 문자열로 구성되어야 하며, payload는 JSON 구조여야 합니다.
    ///    - payload는 base64 URL-safe 포맷이기 때문에 `=` 패딩이 누락될 수 있으며,
    ///      이를 보정하기 위해 `base64Padded()`를 사용합니다.
    ///
    /// - Warning:
    ///    - `token`이 올바르지 않은 형식이거나 payload 디코딩에 실패할 경우,
    ///      적절한 디버깅 메시지가 출력되며 함수는 조용히 종료됩니다.
    ///
    /// - Example:
    /// ```swift
    /// let token = "eyJhbGci~.eyJzdWIiOi~.SflKxwRJSMeKK~V_adQ~"
    /// debugPrintTokenPayload(token)
    /// ```
    ///
    /// - Output:
    /// ```
    /// DEBUG: JWT Payload >>>
    /// DEBUG: - iat: 1744269500
    /// DEBUG: - exp: 1744206900
    /// DEBUG: - sub: 123
    /// DEBUG: exp 존재함 >>> 1744206900.0 (2025-04-10 17:35:00)
    /// ```
    func debugPrintTokenPayload(_ token: String) {
        let parts = token.split(separator: ".")

        guard parts.count == 3 else {
            print("DEBUG: JWT 구조가 올바르지 않습니다.")
            return
        }

        let payloadBase64 = String(parts[1]).base64Padded()

        guard let payloadData = Data(base64Encoded: payloadBase64) else {
            print("DEBUG: payload base64 디코딩 실패")
            return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: payloadData),
              let json = jsonObject as? [String: Any] else {
            print("DEBUG: payload JSON 파싱 실패")
            return
        }

        print("DEBUG: JWT Payload >>>")
        for (key, value) in json {
            print("DEBUG: - \(key): \(value)")
        }

        if let exp = json["exp"] as? TimeInterval {
            let date = Date(timeIntervalSince1970: exp)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = .current

            print("DEBUG: exp 존재함 >>> \(exp) (\(formatter.string(from: date)))")
        } else {
            print("DEBUG: exp 필드 없음")
        }
    }
}
*/
