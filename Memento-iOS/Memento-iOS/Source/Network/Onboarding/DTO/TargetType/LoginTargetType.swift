//
//  LoginTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

enum LoginTargetType {
    case login(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String)
}

extension LoginTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .noTokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var path: String {
        switch self {
        case .login:
            return "\(utilPath.rawValue)" // 결과: "/api/v1/members"
        }
    }
    
    var method: Moya.Method {
        return .put
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case let .login(provider, idToken, timeZoneOffset, fcmToken):
            return LoginRequest(
                provider: provider,
                idToken: idToken,
                timeZoneOffset: timeZoneOffset,
                fcmToken: fcmToken
            )
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
