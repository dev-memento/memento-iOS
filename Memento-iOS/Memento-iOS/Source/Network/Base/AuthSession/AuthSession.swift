import Foundation
import Moya
import Combine
import AuthenticationServices
import Firebase
import FirebaseAuth
import FirebaseMessaging
import GoogleSignIn

@MainActor
final class AuthSession: ObservableObject {
    static let shared = AuthSession()

    // MARK: - Session State
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var shouldStartOnboarding: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    let keychain = TokenKeychainManager.shared
    let memberService = MemberAPIService()
    var hasValidAccessToken: Bool {
          keychain.hasValidToken()
      }

    private init() {
        isLoggedIn = keychain.hasValidToken()
    }
    
    // MARK: - 세션 초기화 담당
    func clear() {
        do { try keychain.clearTokens() } catch {
            print("[AuthSession] token clear failed: \(error)")
        }
        isLoggedIn = false
        shouldStartOnboarding = false
        errorMessage = nil
        isLoading = false
    }

    // MARK: - Error/Helper
    func handleError(_ error: Error?, defaultMessage: String) {
        let message = error?.localizedDescription ?? defaultMessage
        print("🚧 [AuthSession] Error: \(message)")
        errorMessage = message
        isLoading = false
    }
    
    // MARK: - 자동 로그인
    func autoLoginOnLaunch() {
        // Access 토큰이 있고 아직 만료 전이면 로그인 상태로만 세팅
        if let token = try? keychain.getAccessToken(),
            !token.isEmpty,
           !keychain.isTokenExpired(token) {
            isLoggedIn = true
            shouldStartOnboarding = false
        } else {
            // 만료/부재 → 로그인 화면. 실제 호출 시 401이면 인터셉터가 갱신 시도
            isLoggedIn = false
            shouldStartOnboarding = false
        }
    }
    
    // MARK: - 추후 로그아웃, 탈퇴 로직 여기에 위치
}
