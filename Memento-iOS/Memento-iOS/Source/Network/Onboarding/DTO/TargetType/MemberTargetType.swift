//
//  LoginTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

enum MemberTargetType {
    case socialLogin(provider: String, idToken: String, timeZoneOffset: String, fcmToken: String)
    case withdraw
}

extension MemberTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        switch self {
        case .socialLogin: return .noTokenHeader
        case .withdraw:    return .accessTokenHeader
        }
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var path: String { utilPath.rawValue }
    
    var method: Moya.Method {
        return .put
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case let .socialLogin(provider, idToken, timeZoneOffset, fcmToken):
            return LoginRequest(
                provider: provider,
                idToken: idToken,
                timeZoneOffset: timeZoneOffset,
                fcmToken: fcmToken
            )
        case .withdraw:
            return nil
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
