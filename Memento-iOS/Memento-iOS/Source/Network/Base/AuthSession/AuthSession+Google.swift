//
//  AuthSession+Google.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import UIKit

import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseMessaging

// MARK: - Google 로그인 이후 idToken 가져오기 담당

@MainActor
extension AuthSession {
    func signInWithGoogle() {
        Task { @MainActor in
            guard !isLoading else { return }
            isLoading = true
            
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
                    Task { @MainActor in
                        guard let self else { return }
                        await self.authenticateGoogleUser(for: user, with: error)
                    }
                }
                return
            }
            
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                handleError(nil, defaultMessage: "Google 클라이언트 ID 누락")
                return
            }
            
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
            
            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let rootVC = windowScene.windows.first?.rootViewController
            else {
                handleError(nil, defaultMessage: "루트 뷰 컨트롤러를 찾을 수 없습니다.")
                return
            }
            
            do {
                let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
                await authenticateGoogleUser(for: result.user, with: nil)
            } catch {
                handleError(error, defaultMessage: "Google 로그인 실패")
            }
        }
    }
    
    fileprivate func authenticateGoogleUser(for user: GIDGoogleUser?, with error: Error?) async {
        defer { isLoading = false }
        
        if let error {
            handleError(error, defaultMessage: "Google 로그인 실패")
            return
        }
        
        guard
            let idToken = user?.idToken?.tokenString,
            let accessToken = user?.accessToken.tokenString
        else {
            handleError(nil, defaultMessage: "Google 사용자 토큰 누락")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        do {
            
            // Firebase 로그인 (세션 연결)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            
            // 서버에도 로그인 요청
            await requestLogin(provider: "GOOGLE", idToken: idToken)
            
        } catch {
            handleError(error, defaultMessage: "Firebase 세션 연결 실패")
        }
    }
}
