//
//  AuthSession+Apple.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import Foundation

import AuthenticationServices
import FirebaseMessaging


// MARK: - APPLE 로그인 이후 idToken 가져오기 담당

@MainActor
extension AuthSession {
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

    fileprivate func processAppleAuthorization(_ authorization: ASAuthorization) async {
        guard
            let cred = authorization.credential as? ASAuthorizationAppleIDCredential,
            let idTokenData = cred.identityToken,
            let idTokenString = String(data: idTokenData, encoding: .utf8)
        else {
            handleError(nil, defaultMessage: "Apple 사용자 인증 정보 누락")
            return
        }

        await requestLogin(provider: "APPLE", idToken: idTokenString)
    }
}
