//
//  AuthSession+Apple.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import Foundation

import AuthenticationServices
import FirebaseMessaging
import FirebaseAuth
import CryptoKit

// MARK: - APPLE 로그인 이후 idToken 가져오기 담당

@MainActor
extension AuthSession {
    
    // MARK: Apple 로그인 요청 준비
    /// Apple 로그인 요청을 초기화할 때 호출되는 메서드.
    /// - nonce(랜덤 문자열)를 생성해 요청에 심어 넣음 → 보안 공격(리플레이 공격) 방지.
    /// - 로그인 시 사용자 정보(fullName, email) 스코프 요청.

    func prepareAppleSignIn(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogin
    }
    
    // MARK: Apple 로그인 완료 핸들러
    /// Apple 로그인 UI 완료 후 결과(Result)를 받아 처리하는 메서드.
    /// - 성공 시: `processAppleAuthorization` 호출.
    /// - 실패 시: 에러 메시지 출력.
    
    func handleAppleSignInCompletion(_ result: Result<ASAuthorization, Error>) {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            
            switch result {
            case .success(let authorization):
                await processAppleAuthorization(authorization)
            case .failure(let error):
                print("Apple 로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Firebase 세션 연결
    /// Apple 로그인 성공 시 내려온 credential에서 idToken 추출 후 Firebase Auth와 연결.
    /// - Apple ID Credential에서 identityToken 추출.
    /// - Firebase OAuthCredential 생성 후 `Auth.auth().signIn` 실행.
    /// - Firebase 세션 연결 성공 시, 서버 API 로그인까지 요청.
    
    fileprivate func processAppleAuthorization(_ authorization: ASAuthorization) async {
        guard
            let cred = authorization.credential as? ASAuthorizationAppleIDCredential,
            let idTokenData = cred.identityToken,
            let idTokenString = String(data: idTokenData, encoding: .utf8),
            let nonce = currentNonce
        else {
            print("Apple 사용자 인증 정보 누락")
            return
        }
        
        // Firebase Credential 생성
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        do {
            // Firebase 로그인 (세션 연결)
            let result = try await Auth.auth().signIn(with: firebaseCredential)
            
            // 서버에도 로그인 요청
            await requestLogin(provider: "APPLE", idToken: idTokenString)
            
        } catch {
            print("Firebase 세션 연결 실패: \(error.localizedDescription)")
        }
    }
    
    /// Apple → Firebase 로그인 연결할 때 리플레이 공격 방지를 위해 nonce(랜덤 문자열)를 사용
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    /// SHA256 변환 (Firebase가 검증할 때 필요)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
