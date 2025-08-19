//
//  TokenRefreshPlugin.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//
import Foundation
import Moya
import Alamofire

enum AFSessionFactory {
    /// 일반 요청용 (TokenInterceptor 장착)
    static let shared: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return Session(configuration: config, interceptor: TokenInterceptor.shared)
    }()

    /// 리프레시 전용 (인터셉터 없음) — re-entrancy 방지
    static let refreshOnly: Session = {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return Session(configuration: config, interceptor: nil)
    }()
}


final class TokenInterceptor: RequestInterceptor {

    static let shared = TokenInterceptor()

    private let lock = NSLock()
    private var isRefreshing = false
    private var pendingCompletions: [((RetryResult) -> Void)] = []

    private let baseURLString: String? = Bundle.main.infoDictionary?["BASE_URL"] as? String

    private init() {}

    // MARK: - Authorization 보정 (필요 시에만)
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var req = urlRequest

        guard isOurAPI(req) else { completion(.success(req)); return }
        if isLogin(req) || isRefresh(req) { completion(.success(req)); return }

        // 현재 요청의 Authorization (있을 수도, 없을 수도)
        let currentHeader = req.value(forHTTPHeaderField: "Authorization")
        let currentBearer = extractBearer(from: currentHeader)

        // Keychain의 최신 액세스 토큰
        let latestToken: String? = {
            do {
                guard let token = try TokenKeychainManager.shared.getAccessToken(),
                      !token.isEmpty
                else { return nil }
                return token
            } catch {
                return nil
            }
        }()

        // 1) 헤더가 없고 최신 토큰이 있으면 → 주입
        if currentBearer == nil, let latest = latestToken {
            req.setValue("Bearer \(latest)", forHTTPHeaderField: "Authorization")
            completion(.success(req)); return
        }

        // 2) 헤더가 있는데 값이 오래됐으면 → 최신으로 교체
        if let current = currentBearer, let latest = latestToken, current != latest {
            req.setValue("Bearer \(latest)", forHTTPHeaderField: "Authorization")
            completion(.success(req)); return
        }

        // 3) 그 외(이미 최신/토큰 없음) → 그대로 통과
        completion(.success(req))
    }

    // MARK: - 401 → 리프레시 후 재시도
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {

        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401,
              !isRefresh(request) // 리프레시 자체 401은 루프 방지
        else {
            completion(.doNotRetryWithError(error))
            return
        }

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
                // 재시도 시 adapt가 다시 호출되고, 최신 토큰으로 '보정'됨
                completions.forEach { $0(.retry) }
            } else {
                try? TokenKeychainManager.shared.clearTokens()
                DispatchQueue.main.async { AuthSession.shared.isLoggedIn = false }
                completions.forEach { $0(.doNotRetry) }
            }
        }
    }

    // MARK: - Refresh

    /// 실제 리프레시 호출 (Authorization: Bearer <refresh_token>)
    // TokenInterceptor.swift (중요 부분만 발췌)
    private func refreshTokens(completion: @escaping (Bool) -> Void) {
        guard let refresh: String = ((try? TokenKeychainManager.shared.getRefreshToken()) ?? nil),
              !refresh.isEmpty else { completion(false); return }

        let provider = MoyaProvider<TokenRefreshTargetType>(
            session: AFSessionFactory.refreshOnly,          // 전용 세션 (교착 방지)
            plugins: [MoyaPlugin.shared]
        )

        provider.request(.auth(refreshToken: refresh)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 401 {
                    self.forceRelogin()
                    completion(false)
                    return
                }

                guard (200..<300).contains(response.statusCode) else {
                    completion(false); return
                }

                do {
                    let dto = try JSONDecoder().decode(NewAccessTokenResponse.self, from: response.data)
                    let access = dto.data.accessToken.replacingOccurrences(of: "Bearer ", with: "")
                    let newRef = dto.data.refreshToken.replacingOccurrences(of: "Bearer ", with: "")
                    try TokenKeychainManager.shared.saveAccessToken(access)
                    try TokenKeychainManager.shared.saveRefreshToken(newRef)
                    completion(true)
                } catch {
                    completion(false)
                }

            case .failure(let err):
                // 네트워크 오류(오프라인 등)라면 여기선 재로그인 강제 X (원하면 정책에 맞게)
                print("refresh error:", err.localizedDescription)
                completion(false)
            }
        }
    }


    // MARK: - Helpers

    private func isOurAPI(_ req: URLRequest) -> Bool {
        guard let base = baseURLString, let url = req.url else { return false }
        return url.absoluteString.hasPrefix(base)
    }

    private func isLogin(_ req: URLRequest) -> Bool {
        let path = req.url?.path ?? ""
        let method = req.httpMethod ?? "GET"
        return method == "PUT" && path == "/v1/members"
    }

    private func isRefresh(_ req: URLRequest) -> Bool {
        let path = req.url?.path ?? ""
        return path == "/v1/auth/token/refresh"
    }

    private func isRefresh(_ request: Request) -> Bool {
        request.request.flatMap(isRefresh) ?? false
    }

    /// "Bearer xxx" → "xxx"
    private func extractBearer(from header: String?) -> String? {
        guard let header, header.hasPrefix("Bearer ") else { return nil }
        return String(header.dropFirst("Bearer ".count))
    }
    
    private func forceRelogin() {
        try? TokenKeychainManager.shared.clearTokens()
        DispatchQueue.main.async {
            AuthSession.shared.isLoggedIn = false   // 루트에서 LoginView로 전환
        }
    }
}
