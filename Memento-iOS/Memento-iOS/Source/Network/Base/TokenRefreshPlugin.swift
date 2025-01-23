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

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case .failure(let error) = result,
              let response = error.response,
              response.statusCode == 401 else { return }
        
        print("401 Unauthorized detected for URL: \(response.request?.url?.absoluteString ?? "Unknown URL")")
        
        handleTokenRefresh { [weak self] success in
            guard let self = self else { return }
            
            if success {
                print("Token successfully refreshed. Retrying request...")
                self.retryMoyaRequest(target: target)
            } else {
                print("Token refresh failed.")
            }
        }
    }

    private func handleTokenRefresh(completion: @escaping (Bool) -> Void) {
        guard !isRefreshing else {
            refreshQueue.append(completion)
            return
        }

        isRefreshing = true

        do {
            guard let refreshToken = try keychainManager.loadRefreshToken() else {
                print("리프레시 토큰 없음")
                completeRefresh(success: false)
                return
            }

            refreshProvider.request(.auth(refreshToken: refreshToken)) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    do {
                        guard (200...299).contains(response.statusCode) else {
                            print("갱신 실패: 상태 코드 \(response.statusCode)")
                            self.completeRefresh(success: false)
                            return
                        }

                        let decodedResponse = try JSONDecoder().decode(NewAccessTokenResponse.self, from: response.data)
                        try self.keychainManager.saveAccessToken(decodedResponse.accessToken)
                        try self.keychainManager.saveRefreshToken(decodedResponse.refreshToken)
                        print("Access Token 갱신 성공")
                        self.completeRefresh(success: true)

                    } catch {
                        print("디코딩 실패: \(error.localizedDescription)")
                        self.completeRefresh(success: false)
                    }

                case .failure(let error):
                    print("네트워크 오류: \(error.localizedDescription)")
                    self.completeRefresh(success: false)
                }
            }
        } catch {
            print("리프레시 토큰 로드 실패: \(error.localizedDescription)")
            completeRefresh(success: false)
        }
    }

    private func retryMoyaRequest(target: TargetType) {
        guard let moyaTarget = target as? UserInfoTargetType else {
            print("재요청 실패: 잘못된 TargetType")
            return
        }
        
        let provider = MoyaProvider<UserInfoTargetType>(plugins: [self])
        
        provider.request(moyaTarget) { result in
            switch result {
            case .success(let response):
                print("재요청 성공: \(response.statusCode)")
            case .failure(let error):
                print("재요청 실패: \(error.localizedDescription)")
            }
        }
    }

    private func completeRefresh(success: Bool) {
        isRefreshing = false
        refreshQueue.forEach { $0(success) }
        refreshQueue.removeAll()
    }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        let url = try self.baseURL.appendingPathComponent(self.path)
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        switch self.task {
        case .requestParameters(let parameters, let encoding):
            request = try encoding.encode(request, with: parameters)
        case .requestJSONEncodable(let encodable):
            request.httpBody = try JSONEncoder().encode(encodable)
        default:
            break
        }

        self.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
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
