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
    private let tokenRefreshProvider = MoyaProvider<TokenRefreshType>(plugins: [MoyaPlugin.shared])
    private var isRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        print("TokenRefreshPlugin - process called")  // 디버깅용 로그
        
        switch result {
        case .failure(let error):
            if let response = error.response, response.statusCode == 401 {
                print("TokenRefreshPlugin - 401 error detected")  // 디버깅용 로그
                
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
        case .success(let response):
            print("TokenRefreshPlugin - Success response: \(response.statusCode)")  // 디버깅용 로그
        }
        
        return result
    }


    private func handleTokenRefresh(completion: @escaping (Bool) -> Void) {
        guard !isRefreshing else {
            refreshQueue.append(completion)
            return
        }

        isRefreshing = true

        do {
            guard let refreshToken = try keychainManager.getRefreshToken() else {
                print("[ERROR] No Refresh Token Available")
                completeRefresh(success: false)
                return
            }

            tokenRefreshProvider.request(.auth(refreshToken: refreshToken)) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    if (200..<300).contains(response.statusCode) {
                        do {
                            let decodedResponse = try JSONDecoder().decode(NewAccessTokenResponse.self, from: response.data)
                            try self.keychainManager.saveAccessToken(decodedResponse.accessToken)
                            try self.keychainManager.saveRefreshToken(decodedResponse.refreshToken)
                            print("[INFO] Access Token successfully refreshed.")
                            self.completeRefresh(success: true)
                        } catch {
                            print("[ERROR] Failed to decode token refresh response: \(error.localizedDescription)")
                            self.completeRefresh(success: false)
                        }
                    } else {
                        print("[ERROR] Token refresh failed with status code: \(response.statusCode)")
                        self.completeRefresh(success: false)
                    }

                case .failure(let error):
                    print("[ERROR] Token refresh network error: \(error.localizedDescription)")
                    self.completeRefresh(success: false)
                }
            }
        } catch {
            print("[ERROR] Failed to load refresh token from Keychain: \(error.localizedDescription)")
            completeRefresh(success: false)
        }
    }

    private func retryMoyaRequest(target: TargetType) {
        guard let moyaTarget = target as? UserInfoTargetType else {
            print("[ERROR] Unable to retry request - invalid TargetType")
            return
        }

        let provider = MoyaProvider<UserInfoTargetType>(plugins: [self])

        provider.request(moyaTarget) { result in
            switch result {
            case .success(let response):
                print("[INFO] Retry request successful with status code: \(response.statusCode)")
            case .failure(let error):
                print("[ERROR] Retry request failed: \(error.localizedDescription)")
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


