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
    // 경로/URL 한 곳에서 관리
    static let baseURLString = Config.baseURL
    static let refreshPath   = "/v1/auth/token/refresh"
    static var refreshURL: URL? { URL(string: baseURLString + refreshPath) }
    
    /// 인터셉터 없는 전용 세션 사용
    static func refreshTokens(using session: Session = AFSessionFactory.refreshOnly,
                              keychain: TokenKeychainManager = .shared,
                              completion: @escaping (Result<TokenData, Error>) -> Void) {
        // 1) 키체인에서 refresh 로드
        guard let raw = try? keychain.getRefreshToken(), !raw.isEmpty,
              let url = refreshURL
        else {
            completion(.failure(NSError(domain: "Refresh", code: -1, userInfo: [NSLocalizedDescriptionKey: "No refresh token"])))
            return
        }
        
        let refresh = raw.hasPrefix("Bearer ") ? String(raw.dropFirst(7)) : raw
        
        // 2) URLRequest 조립 (필요하면 body 추가)
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(refresh)", forHTTPHeaderField: "Authorization")
        // req.httpBody = ...  // 서버가 body를 요구하면 넣기
        
        // 3) 호출
        session.request(req)
            .validate(statusCode: 200..<300)
            .responseData { resp in
                switch resp.result {
                case .success(let data):
                    do {
                        let dto = try JSONDecoder().decode(NewAccessTokenResponse.self, from: data)
                        let access = dto.data.accessToken.replacingOccurrences(of: "Bearer ", with: "")
                        let newRef = dto.data.refreshToken.replacingOccurrences(of: "Bearer ", with: "")
                        completion(.success(TokenData(accessToken: access, refreshToken: newRef)))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let afError):
                    completion(.failure(afError))
                }
            }
    }
}
