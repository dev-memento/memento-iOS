//
//  TokenRefreshPlugin.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

final class TokenRefreshPlugin: PluginType {
    private let keychainManager = TokenKeychainManager.shared
    private let refreshProvider = MoyaProvider<TokenRefreshType>()
    private var isRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []
    
    /// `didReceive` 메서드에서 401 응답 처리
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case .failure(let error) = result,
              let response = error.response,
              response.statusCode == 401 else { return }
        
        handleTokenRefresh { success in
            if success {
                print("토큰 갱신 성공")
                // 필요시 갱신 후 추가 작업
            } else {
                print("토큰 갱신 실패")
                // 갱신 실패 시 추가 작업
            }
        }
    }
    
    /// Access Token 갱신 로직
    private func handleTokenRefresh(completion: @escaping (Bool) -> Void) {
        // 동시성 문제 방지: 이미 갱신 중이면 큐에 추가
        guard !isRefreshing else {
            refreshQueue.append(completion)
            return
        }
        
        isRefreshing = true
        
        do {
            // Keychain에서 Refresh Token 로드
            guard let refreshToken = try keychainManager.loadRefreshToken() else {
                print("리프레시 토큰 없음")
                completeRefresh(success: false)
                return
            }
            
            // Refresh Token 요청
            refreshProvider.request(.refreshToken(refreshToken: refreshToken)) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    do {
                        // 상태 코드 확인 및 데이터 처리
                        guard (200...299).contains(response.statusCode) else {
                            print("서버 응답 상태 코드 에러: \(response.statusCode)")
                            self.completeRefresh(success: false)
                            return
                        }
                        
                        // 응답 데이터 디코딩
                        let decodedResponse = try JSONDecoder().decode(NewAccessTokenResponse.self, from: response.data)
                        
                        // 새로운 Access Token 저장
                        try self.keychainManager.saveAccessToken(decodedResponse.accessToken)
                        try self.keychainManager.saveRefreshToken(decodedResponse.refreshToken)
                        
                        print("Access Token 갱신 성공")
                        self.completeRefresh(success: true)
                        
                    } catch {
                        // 디코딩 오류 처리
                        print("디코딩 실패: \(error.localizedDescription)")
                        self.completeRefresh(success: false)
                    }
                    
                case .failure(let error):
                    // 네트워크 오류 처리
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.completeRefresh(success: false)
                }
            }
        } catch {
            // Keychain 에러 처리
            print("리프레시 토큰 로드 실패: \(error.localizedDescription)")
            completeRefresh(success: false)
        }
    }
    
    /// 토큰 갱신 완료 처리 및 대기 중인 요청 처리
    private func completeRefresh(success: Bool) {
        isRefreshing = false
        refreshQueue.forEach { $0(success) }
        refreshQueue.removeAll()
    }
}

/*
 // 인증이 필요없는 API (로그인, 회원가입 등)
 let provider = MoyaProvider<LoginTargetType>(plugins: [MoyaPlugin.shared])
 
 // 인증이 필요한 API
 let authenticatedProvider = MoyaProvider<UserTargetType>(
 plugins: [MoyaPlugin.shared, TokenRefreshPlugin()]
 )
 */
