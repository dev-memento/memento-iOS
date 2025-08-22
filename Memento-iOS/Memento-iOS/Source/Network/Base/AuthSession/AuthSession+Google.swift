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
            
            guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
                handleError(nil, defaultMessage: "루트 뷰 컨트롤러를 찾을 수 없습니다.")
                return
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
                Task { @MainActor in
                    guard let self else { return }
                    if let result { await self.authenticateGoogleUser(for: result.user, with: error) }
                    else { self.handleError(error, defaultMessage: "Google 로그인 실패") }
                }
            }
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            print("Google 로그아웃 성공")
        } catch {
            print("Google 로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    fileprivate func authenticateGoogleUser(for user: GIDGoogleUser?, with error: Error?) async {
        defer { isLoading = false }
        if let error { handleError(error, defaultMessage: "Google 로그인 실패"); return }
        
        guard let idToken = user?.idToken?.tokenString else {
            handleError(nil, defaultMessage: "Google 사용자 토큰 누락")
            return
        }
        await requestLogin(provider: "GOOGLE", idToken: idToken)
    }
}
