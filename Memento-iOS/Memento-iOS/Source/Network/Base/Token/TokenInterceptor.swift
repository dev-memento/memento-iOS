//
//  TokenInterceptor.swift
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
        config.timeoutIntervalForRequest = 20 // 응답 대기 최대 시간
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData // 캐시 사용 x 무조건 서버 원본
        return Session(configuration: config, interceptor: TokenInterceptor.shared)
    }()
    
    /// 리프레시 전용(인터셉터 없음) — 동일 세션 재진입/교착 방지
    static let refreshOnly: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20
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

    // MARK: 요청이 나가기 직전 토큰 삽입
    /// 우리 API일 때만 가로채기 로그인, 리프래시 요청이면 토큰 삽입 x

    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest

        guard isOurAPI(req) else { completion(.success(req)); return }

        // 로그인/리프레시 스킵
        if isLogin(req) || isRefresh(req) {
            completion(.success(req)); return
        }

        if let access = try? TokenKeychainManager.shared.getAccessToken(), !access.isEmpty {
            req.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(req))
    }

    // MARK: 401 에러 발생시 리프래시 갱신 실행
    /// 동시 401 요청이 전부 refreshTokens()를 호출 → 서버에 중복 리프레시 요청 남발
    /// lock.lock()으로 첫 요청만 리프레시 담당자가 되고, 나머지는 pendingCompletions 배열에 합류해서 리프레시 끝날 때까지 대기
    
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

    // MARK: Refresh 갱신 API 호출
    /// 리프래시 토큰 401 만료 시 강제 다시 로그인 화면으로

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
    
    // MARK: - 우리 API 요청 검증, 구글 API 요청에는 손대지 않으려는 목적
    
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
