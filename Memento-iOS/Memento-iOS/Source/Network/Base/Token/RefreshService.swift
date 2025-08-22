//
//  RefreshService.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import Foundation

import Alamofire
import Moya

enum RefreshService {
    
    // MARK: - Endpoint
    
    static let apiBaseURL        = Config.baseURL
    static let tokenRefreshPath  = "/v1/auth/token/refresh"
    static var tokenRefreshURL: URL? { URL(string: apiBaseURL + tokenRefreshPath) }
    
    enum RefreshError: LocalizedError {
        case missingRefreshToken
        case invalidURL
        case decodingFailed(Error)
        case transport(Error)
        
        var errorDescription: String? {
            switch self {
            case .missingRefreshToken: return "리프레시 토큰이 없습니다."
            case .invalidURL:          return "리프레시 URL이 올바르지 않습니다."
            case .decodingFailed(let e): return "토큰 파싱 실패: \(e.localizedDescription)"
            case .transport(let e):      return "네트워크 오류: \(e.localizedDescription)"
            }
        }
    }
    
    /// 인터셉터 없는 세션을 사용해 토큰을 갱신합니다.
    static func refreshTokens(
        using session: Session = AFSessionFactory.refreshOnly,
        keychain: TokenKeychainManager = .shared,
        completion: @escaping (Result<TokenData, Error>) -> Void
    ) {
        // 1) 키체인에서 refresh 로드
        guard let storedRefreshToken = try? keychain.getRefreshToken(),
              !storedRefreshToken.isEmpty
        else {
            completion(.failure(RefreshError.missingRefreshToken))
            return
        }
        guard let url = tokenRefreshURL else {
            completion(.failure(RefreshError.invalidURL))
            return
        }
        
        // 2) "Bearer " 제거해 순수 토큰으로 정규화
        let refreshToken = storedRefreshToken.hasPrefix("Bearer ")
        ? String(storedRefreshToken.dropFirst(7))
        : storedRefreshToken
        
        // 3) URLRequest 구성
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        // request.httpBody = ... // 서버가 body 요구 시 추가
        
        // 4) 호출 & 응답 처리
        session.request(request)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let responseDTO = try JSONDecoder().decode(NewAccessTokenResponse.self, from: data)
                        let normalizedAccess  = responseDTO.data.accessToken.replacingOccurrences(of: "Bearer ", with: "")
                        let normalizedRefresh = responseDTO.data.refreshToken.replacingOccurrences(of: "Bearer ", with: "")
                        completion(.success(TokenData(accessToken: normalizedAccess,
                                                      refreshToken: normalizedRefresh)))
                    } catch {
                        completion(.failure(RefreshError.decodingFailed(error)))
                    }
                case .failure(let afError):
                    completion(.failure(RefreshError.transport(afError)))
                }
            }
    }
}
