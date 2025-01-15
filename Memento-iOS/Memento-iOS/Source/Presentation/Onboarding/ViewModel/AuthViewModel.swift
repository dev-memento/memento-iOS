//
//  AuthViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/15/25.
//

import SwiftUI
import Combine
import AuthenticationServices

enum AuthAction {
    case appleLogin(ASAuthorizationAppleIDRequest)
    case appleLoginCompletion(Result<ASAuthorization, Error>)
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    func send(action: AuthAction) {
        switch action {
        case .appleLogin(let request):
            handleAppleLogin(request)
        case .appleLoginCompletion(let result):
            handleAppleLoginCompletion(result)
        }
    }
    
    private func handleAppleLogin(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin // 로그인 요청 명시
    }
    
    private func handleAppleLoginCompletion(_ result: Result<ASAuthorization, Error>) {
        isLoading = true
        defer { isLoading = false }
        
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                // Process user data
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // Save user data securely (e.g., Keychain) 저장 할 필요가 없다면 해당 값을 서버에 전달한 후 토큰값 키체인 메니져로 관리하기
                saveUserToKeychain(userIdentifier: userIdentifier)
                
                // Update state
                isAuthenticated = true
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveUserToKeychain(userIdentifier: String) {
        print("userIdentifier \(userIdentifier)")
        // Example: Use Keychain to save userIdentifier
        // KeychainManager.save(userIdentifier, for: "appleUserIdentifier")
    }
}

