//
//  TokenRefreshPlugin.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya
import Alamofire

// MARK: - AFSessionFactory
enum AFSessionFactory {
    /// 일반 요청 (TokenInterceptor 장착)
    static let shared: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return Session(configuration: config, interceptor: TokenInterceptor.shared)
    }()
    
    /// 리프레시 전용(인터셉터 없음) — 동일 세션 재진입/교착 방지
    static let refreshOnly: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return Session(configuration: config, interceptor: nil)
    }()
}

// MARK: - TokenInterceptor
final class TokenInterceptor: RequestInterceptor {
    static let shared = TokenInterceptor()

    private let lock = NSLock()
    private var isRefreshing = false
    private var pendingCompletions: [((RetryResult) -> Void)] = []

    private let baseURLString: String = Config.baseURL
    private let refreshPath = "/v1/auth/token/refresh"
    private var refreshURL: URL? { URL(string: baseURLString + refreshPath) }

    private init() {}

    // MARK: Adapt
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest

        guard isOurAPI(req) else { completion(.success(req)); return }

        // 로그인/리프레시 스킵
        if isLogin(req) || isRefresh(req) {
            completion(.success(req)); return
        }

        // 이미 Authorization 있으면(소셜/특수) 손대지 않음
        if req.value(forHTTPHeaderField: "Authorization") != nil {
            completion(.success(req)); return
        }

        if let access = try? TokenKeychainManager.shared.getAccessToken(), !access.isEmpty {
            req.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(req))
    }

    // MARK: Retry (401 → refresh → retry 1회)
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {

        guard let res = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetryWithError(error)); return
        }

        // 리프레시 자체거나 401 아님 → 재시도 X
        if res.statusCode != 401 || isRefresh(request.request) {
            completion(.doNotRetryWithError(error)); return
        }

        // 같은 원요청은 1회만
        if request.retryCount > 0 {
            forceRelogin()
            completion(.doNotRetry)
            return
        }

        // 동시 401 합류
        lock.lock()
        if isRefreshing {
            pendingCompletions.append(completion)
            lock.unlock()
            return
        }
        isRefreshing = true
        pendingCompletions.append(completion)
        lock.unlock()

        refreshTokens { [weak self] success in
            guard let self else { return }

            self.lock.lock()
            let completions = self.pendingCompletions
            self.pendingCompletions.removeAll()
            self.isRefreshing = false
            self.lock.unlock()

            if success {
                completions.forEach { $0(.retry) }
            } else {
                self.forceRelogin()
                completions.forEach { $0(.doNotRetry) }
            }
        }
    }

    // MARK: Refresh (인터셉터 미적용 세션)
    // TokenRefreshPlugin.swift (일부만 발췌)

    private func refreshTokens(completion: @escaping (Bool) -> Void) {
        RefreshService.refreshTokens { result in
            switch result {
            case .success(let tokenData):
                do {
                    try TokenKeychainManager.shared.saveAccessToken(tokenData.accessToken)
                    try TokenKeychainManager.shared.saveRefreshToken(tokenData.refreshToken)
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure(let err):
                if (err as NSError).code == 401 { self.forceRelogin() }
                completion(false)
            }
        }
    }


    // MARK: Helpers
    private func isOurAPI(_ req: URLRequest) -> Bool {
        guard let url = req.url else { return false }
        return url.absoluteString.hasPrefix(baseURLString)
    }

    private func isLogin(_ req: URLRequest) -> Bool {
        let path = req.url?.path ?? ""
        let method = req.httpMethod ?? "PUT"
        return method == "PUT" && path == "/v1/members"
    }

    private func isRefresh(_ req: URLRequest?) -> Bool {
        guard let path = req?.url?.path else { return false }
        return path == refreshPath
    }

    private func forceRelogin() {
        try? TokenKeychainManager.shared.clearTokens()
        DispatchQueue.main.async {
            AuthSession.shared.isLoggedIn = false
        }
    }
}
