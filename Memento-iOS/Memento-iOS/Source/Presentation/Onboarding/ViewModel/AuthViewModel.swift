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
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[unowned self] result, error in
                guard let result = result else { return }
                authenticateUser(for: result.user, with: error)
            }
        }
    }
    
    // Google 로그인 결과를 Firebase로 연결하여 사용자를 인증하는 함수
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Google 로그인 성공")
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
        isLoading = true
        defer { isLoading = false }
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                print("Apple ID: \(userIdentifier), Full Name: \(String(describing: fullName)), Email: \(String(describing: email))")
                
                self.isAuthenticated = true
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
