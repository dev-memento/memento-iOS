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
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            // 이전 로그인 세션 복구
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            // 새로운 로그인 시도
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
                guard let result = result else {
                    // 로그인 실패 처리
                    self.errorMessage = error?.localizedDescription ?? "Google 로그인 실패"
                    self.isAuthenticated = false
                    return
                }
                authenticateUser(for: result.user, with: error)
            }
        }
    }

    // Google 로그인 결과를 Firebase로 연결하여 사용자를 인증하는 함수
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print("Google 로그인 실패: \(error.localizedDescription)")
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
            return
        }
        
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else {
            print("Google 사용자 토큰 누락")
            self.errorMessage = "Google 사용자 토큰이 누락되었습니다."
            self.isAuthenticated = false
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        // Firebase 인증 처리
        Auth.auth().signIn(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Firebase 인증 실패: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.isAuthenticated = false
            } else {
                print("Google 로그인 및 Firebase 인증 성공")
                self.errorMessage = nil
                self.isAuthenticated = true
            }
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
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                if let appleID = appleIDCredential.identityToken,
                   let authorizationCode = appleIDCredential.authorizationCode {
                    // Base64 또는 UTF-8 문자열로 변환
                    let appleIDString = String(data: appleID, encoding: .utf8) ?? "Invalid token"
                    let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) ?? "Invalid code"
                    
                    print("Apple ID Token: \(appleIDString)")
                    print("Authorization Code: \(authorizationCodeString)")
                }

                print("Apple ID: \(userIdentifier), Full Name: \(String(describing: fullName)), Email: \(String(describing: email))")

                
                // Firebase Auth로 Apple 인증 정보 전달
                Task { @MainActor in
                    do {
                        // Firebase 인증 처리 (필요한 경우)
                        self.errorMessage = nil
                        self.isAuthenticated = true
                    } catch {
                        self.errorMessage = error.localizedDescription
                        self.isAuthenticated = false
                    }
                }
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.isAuthenticated = false
        }
    }
}
