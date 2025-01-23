//
//  BaseTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/19/25.
//

import Foundation

import Moya

enum TokenHealthType {
    case accessToken
    case refreshToken
}

///  헤더에 들어가는 토큰의 상태에 따른 Type
enum HeaderType {
    case socialTokenHeader(socialToken: String)
    case accessTokenHeader
    case refreshTokenHeader
    case tokenHealthHeader(tokenHealthType: TokenHealthType)
    case noTokenHeader
}

/// 각 API에 따라 공통된 Path 값 (존재하지 않는 경우 빈 String 값)
enum UtilPath: String {
    case todo = "/v1/todos"
    case tag = "/v1/tags"
    case schedule = "/v1/schedules"
    case auth = "/v1/auth"
    case user = "/v1/members"
    case health = "/health"
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var utilPath: UtilPath { get }
    var pathParameter: String? { get }
    var queryParameter: [String: Any]? { get }
    var requestBodyParameter: Codable? { get }
}

extension BaseTargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: Config.baseURL) else {
            fatalError("🤖⛔️ Base URL이 없어요! ⛔️🤖")
        }
        return baseURL
    }
    
    var headers: [String: String]? {
        let keychainManager = TokenKeychainManager.shared
        
        var header = ["Content-Type": "application/json"]
        
        switch headerType {
        case .socialTokenHeader(let socialToken):
            header["Authorization"] = "Bearer \(socialToken)"
            
        case .accessTokenHeader:
            if let accessToken = try? keychainManager.loadAccessToken() {
                return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
            } else {
                print("[ERROR] 액세스 토큰 로드 실패")
                return nil
            }
        case .refreshTokenHeader:
            if let refreshToken = try? keychainManager.loadRefreshToken() {
                return ["Authorization": "Bearer \(refreshToken)", "Content-Type": "application/json"]
            } else {
                print("[ERROR] 리프레시 토큰 로드 실패")
                return nil
            }
        case .tokenHealthHeader:
            // 나중에 추가
            // Access Token 또는 Refresh Token의 상태 확인 및 구분
            break
            
        case .noTokenHeader:
            break
        }
        
        return header
    }
    
    var task: Task {
        if let queryParameter {
            return .requestParameters(parameters: queryParameter, encoding: URLEncoding.default)
        }
        if let requestBodyParameter {
            return .requestJSONEncodable(requestBodyParameter)
        }
        return .requestPlain
    }
}
