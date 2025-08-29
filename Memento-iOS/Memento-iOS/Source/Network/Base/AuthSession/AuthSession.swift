//
//  AuthSession.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import Foundation
import Combine

import Moya
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
        // 1. AccessToken이 유효 → 바로 로그인 유지
        if let access = try? TokenKeychainManager.shared.getAccessToken(),
           !access.isEmpty,
           !TokenKeychainManager.shared.isTokenExpired(access) {
            print("AccessToken 유효 → 로그인 유지")
            isLoggedIn = true
            return
        }
        
        // 2. AccessToken이 없거나 만료 → Refresh 시도
        RefreshService.refreshTokens { result in
            switch result {
            case .success(let tokenData):
                do {
                    try TokenKeychainManager.shared.saveAccessToken(tokenData.accessToken)
                    try TokenKeychainManager.shared.saveRefreshToken(tokenData.refreshToken)
                    print("AccessToken만료 -> Refresh 성공 → 새 토큰 저장")
                    
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                } catch {
                    print("❌ 새 토큰 저장 실패: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                    }
                }
                
            case .failure(let error):
                print("❌ Refresh 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
            }
        }
    }
    
    // MARK: - 로그아웃
    func logout() {
        print("로그아웃 실행: 세션/토큰 정리")
        clear()
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }
    
    // MARK: - 회원 탈퇴
    func withdraw() async {
        guard let _ = try? keychain.getAccessToken() else {
            print("⚠️ AccessToken 없음 → 탈퇴 API 호출 생략")
            clear()
            return
        }
        
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            memberService.withdraw { result in
                switch result {
                case .success:
                    print("회원 탈퇴 성공")
                    self.logout() // 로그아웃과 동일하게 세션 정리
                case .unAuthorized:
                    self.clear()
                default:
                    print("회원 탈퇴 실패(서버 오류)")
                }
                cont.resume()
            }
        }
    }
}
