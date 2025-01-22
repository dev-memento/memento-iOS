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
    
    // 서버 API 호출 구현
    let loginService = LoginAPIService()
    
    func send(action: AuthAction){
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
    
    // 구글 로그인을 초기화하고 인증을 시작하는 핵심 함수
    func signInWithGoogle() {
        Task { @MainActor in
            guard !isLoading else { return }
            
            isLoading = true
            
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                    Task { @MainActor in
                        await self?.authenticateUser(for: user, with: error)
                    }
                }
            } else {
                guard let clientID = FirebaseApp.app()?.options.clientID else {
                    isLoading = false
                    return
                }
                
                let configuration = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = configuration
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let rootViewController = windowScene.windows.first?.rootViewController else {
                    isLoading = false
                    return
                }
                
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
                    Task { @MainActor in
                        guard let self = self else { return }
                        
                        if let result = result {
                            await self.authenticateUser(for: result.user, with: error)
                        } else {
                            self.errorMessage = error?.localizedDescription ?? "Google 로그인 실패"
                            self.isAuthenticated = false
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    // Google 로그인 결과를 Firebase로 연결하여 사용자를 인증하는 함수
    @MainActor
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) async {
        defer { isLoading = false }
        
        if let error = error {
            print("Google 로그인 실패: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
            return
        }
        
        guard let accessToken = user?.accessToken.tokenString,
              let idToken = user?.idToken?.tokenString else {
            print("Google 사용자 토큰 누락")
            self.errorMessage = "Google 사용자 토큰이 누락되었습니다."
            self.isAuthenticated = false
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            print("Google 로그인 및 Firebase 인증 성공: idToken \(idToken)")
            self.errorMessage = nil
            self.isAuthenticated = true
            
            // 토큰 저장
            loginService.login(provider: "GOOGLE", idToken: idToken) { result in
                switch result {
                case .success(let response):
                    if let accessToken = response?.data.accessToken,
                       let refreshToken = response?.data.refreshToken {
                        do {
                            try TokenKeychainManager.shared.saveAccessToken(accessToken)
                            try TokenKeychainManager.shared.saveRefreshToken(refreshToken)
                            print("토큰 저장 완료")
                            
                            // 추후 response?.data.isNewUser호 가입 사용자인지 체크 후 화면 전환
                            if let isNewUser = response?.data.isNewUser, isNewUser {
                                print("신규 사용자 - 추가 작업 필요")
                            } else {
                                print("기존 사용자 - 추가 작업 필요")
                            }
                        } catch {
                            print("토큰 저장 실패: \(error.localizedDescription)")
                        }
                    }
                default:
                    print("ERROR")
                }
            }
        } catch {
            print("Firebase 인증 실패: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }
    }
    
    func signOutWithGoogle() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            print("Google 로그아웃 성공")
        } catch {
            print(error.localizedDescription)
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
            
            do {
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                       let appleIDToken = appleIDCredential.identityToken,
                       let authorizationCode = appleIDCredential.authorizationCode,
                       let idTokenString = String(data: appleIDToken, encoding: .utf8),
                       let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) {
                        
                        // Firebase 인증용 credential 생성
                        let credential = OAuthProvider.credential(
                            withProviderID: "apple.com",
                            idToken: idTokenString,
                            accessToken: authorizationCodeString
                        )
                        
                        // Firebase 인증
                        let authResult = try await Auth.auth().signIn(with: credential)
                        print("Apple 로그인 성공: idTokenString \(idTokenString)")
                        self.errorMessage = nil
                        self.isAuthenticated = true
                        
                        // 토큰 저장
                        loginService.login(provider: "APPLE", idToken: idTokenString) { result in
                            switch result {
                            case .success(let response):
                                if let accessToken = response?.data.accessToken,
                                   let refreshToken = response?.data.refreshToken {
                                    do {
                                        try TokenKeychainManager.shared.saveAccessToken(accessToken)
                                        try TokenKeychainManager.shared.saveRefreshToken(refreshToken)
                                        print("토큰 저장 완료")
                                        
                                        // 추후 response?.data.isNewUser호 가입 사용자인지 체크 후 화면 전환
                                        if let isNewUser = response?.data.isNewUser, isNewUser {
                                            print("신규 사용자 - 추가 작업 필요")
                                        } else {
                                            print("기존 사용자 - 추가 작업 필요")
                                        }
                                    } catch {
                                        print("토큰 저장 실패: \(error.localizedDescription)")
                                    }
                                }
                            default:
                                print("ERROR")
                            }
                        }

                    } else {
                        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Apple 인증 정보 누락"])
                    }
                    
                case .failure(let error):
                    throw error
                }
            } catch {
                print("Apple 로그인 실패: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
            }
        }
    }
}
