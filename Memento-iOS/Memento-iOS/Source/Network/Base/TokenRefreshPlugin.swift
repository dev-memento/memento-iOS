//
//  TokenRefreshPlugin.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//
import Foundation
import Moya

final class TokenRefreshPlugin: PluginType {
    private let keychain = TokenKeychainManager.shared
    private let provider = MoyaProvider<TokenRefreshType>(plugins: [MoyaPlugin.shared])
    private var isRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []

    // MARK: - 감지된 401 처리
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard case let .success(response) = result, response.statusCode == 401 else { return }

        print("🔐 [TokenRefreshPlugin] 401 detected. Starting refresh...")

        handleTokenRefresh { success in
            print(success ? "✅ Token refreshed." : "❌ Token refresh failed.")
            // 재시도는 외부에서 해야 함
        }
    }

    // MARK: - 토큰 리프레시 처리
    func handleTokenRefresh(completion: @escaping (Bool) -> Void) {
        guard !isRefreshing else {
            refreshQueue.append(completion)
            return
        }

        isRefreshing = true

        do {
            guard let refreshToken = try keychain.getRefreshToken() else {
                print("[ERROR] No refresh token found.")
                completeRefresh(success: false)
                return
            }

            provider.request(.auth(refreshToken: refreshToken)) { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let response):
                    self.processRefreshResponse(response)
                case .failure(let error):
                    print("[ERROR] Refresh request failed: \(error.localizedDescription)")
                    self.completeRefresh(success: false)
                }
            }

        } catch {
            print("[ERROR] Failed to load refresh token: \(error.localizedDescription)")
            completeRefresh(success: false)
        }
    }

    private func processRefreshResponse(_ response: Response) {
        guard (200..<300).contains(response.statusCode) else {
            print("[ERROR] Token refresh failed with status code: \(response.statusCode)")
            completeRefresh(success: false)
            return
        }

        do {
            let decoded = try JSONDecoder().decode(NewAccessTokenResponse.self, from: response.data)
            try keychain.saveAccessToken(decoded.data.accessToken)
            try keychain.saveRefreshToken(decoded.data.refreshToken)
            print("[INFO] Access token refreshed successfully.")
            completeRefresh(success: true)
        } catch {
            print("[ERROR] Failed to decode token refresh response: \(error)")
            completeRefresh(success: false)
        }
    }

    private func completeRefresh(success: Bool) {
        isRefreshing = false
        refreshQueue.forEach { $0(success) }
        refreshQueue.removeAll()
    }
}

extension MoyaProvider {
    func requestWithTokenRefresh(
        _ target: Target,
        retryCount: Int = 1,
        completion: @escaping (Result<Response, MoyaError>) -> Void
    ) {
        self.request(target) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                if response.statusCode == 401 && retryCount > 0 {
                    print("🔄 [Moya] 401 detected, refreshing token...")

                    TokenRefreshPlugin().handleTokenRefresh { success in
                        if success {
                            print("✅ Retry after refresh")
                            self.requestWithTokenRefresh(target, retryCount: retryCount - 1, completion: completion)
                        } else {
                            print("❌ Token refresh failed")
                            completion(.failure(.underlying(NSError(domain: "Token refresh failed", code: 401), nil)))
                        }
                    }
                } else {
                    completion(.success(response))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
