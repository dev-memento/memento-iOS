//
//  AuthViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/15/25.
//

import SwiftUI
import Combine
import AuthenticationServices
import Firebase
import FirebaseAuth
import GoogleSignIn

enum AuthAction {
    case googleLogin
    case googleLogOut
    case appleLogin(ASAuthorizationAppleIDRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    let loginService = LoginAPIService()

    func send(action: AuthAction) {
        switch action {
        case .googleLogin:
            signInWithGoogle()
        case .googleLogOut:
            signOutWithGoogle()
        case .appleLogin(let request):
            signInWithApple(request)
        case .appleLoginCompletion(let result):
            signInWithAppleCompletion(result)
        }
    }

    func signInWithGoogle() {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true

            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                    Task { @MainActor in
                        guard let self = self else { return }
                        await self.authenticateUser(for: user, with: error)
                    }
                }
            } else {
                guard let clientID = FirebaseApp.app()?.options.clientID else {
                    handleError(nil, defaultMessage: "Google 클라이언트 ID 누락")
                    return
                }
                
                let configuration = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = configuration

                guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
                    handleError(nil, defaultMessage: "루트 뷰 컨트롤러를 찾을 수 없습니다.")
                    return
                }

                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
                    Task { @MainActor in
                        guard let self = self else { return }
                        if let result = result {
                            await self.authenticateUser(for: result.user, with: error)
                        } else {
                            self.handleError(error, defaultMessage: "Google 로그인 실패")
                        }
                    }
                }
            }
        }
    }

    func signOutWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            print("Google 로그아웃 성공")
        } catch {
            print("Google 로그아웃 실패: \(error.localizedDescription)")
        }
    }

    private func signInWithApple(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
    }

    private func signInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
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
        self.isAuthenticated = false
        self.isLoading = false
    }
}

//MARK: HTTP Memento 서버 통신 부분

extension AuthViewModel {
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) async {
        defer { isLoading = false }

        if let error = error {
            handleError(error, defaultMessage: "Google 로그인 실패")
            return
        }

        guard let idToken = user?.idToken?.tokenString else {
            handleError(nil, defaultMessage: "Google 사용자 토큰 누락")
            return
        }

        loginService.login(provider: "GOOGLE", idToken: idToken) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.handleLoginSuccess(response?.data)
            case .unAuthorized:
                self.handleError(nil, defaultMessage: "인증 실패. 다시 로그인하세요.")
            default:
                self.handleError(nil, defaultMessage: "서버 오류가 발생했습니다.")
            }
        }
    }

    private func processAppleAuthorization(_ authorization: ASAuthorization) async {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTokenData = appleIDCredential.identityToken,
              let idTokenString = String(data: idTokenData, encoding: .utf8) else {
            handleError(nil, defaultMessage: "Apple 사용자 인증 정보 누락")
            return
        }

        loginService.login(provider: "APPLE", idToken: idTokenString) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.handleLoginSuccess(response?.data)
            case .unAuthorized:
                self.handleError(nil, defaultMessage: "인증 실패. 다시 로그인하세요.")
            default:
                self.handleError(nil, defaultMessage: "서버 오류가 발생했습니다.")
            }
        }
    }

    private func handleLoginSuccess(_ data: LoginResponseData?) {
        guard let data else { return }
        do {
            try TokenKeychainManager.shared.saveAccessToken(data.accessToken)
            try TokenKeychainManager.shared.saveRefreshToken(data.refreshToken)
            self.isAuthenticated = true
            print("로그인 성공 및 토큰 저장 완료")
        } catch {
            handleError(error, defaultMessage: "토큰 저장 실패")
        }
    }
}
