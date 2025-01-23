//
//  TokenRefreshType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

enum TokenRefreshType {
    case auth(refreshToken: String)
}

extension TokenRefreshType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        switch self {
        case .auth(let refreshToken):
            return .socialTokenHeader(socialToken: refreshToken) // Refresh Token을 Authorization 헤더에 추가
        }
    }
    
    var utilPath: UtilPath {
        return .auth
    }
    
    var path: String {
        switch self {
        case .auth:
            return "\(utilPath.rawValue)/token/refresh" // 결과: "/v1/auth/token/refresh"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var requestBodyParameter: Codable? {
        return nil 
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
