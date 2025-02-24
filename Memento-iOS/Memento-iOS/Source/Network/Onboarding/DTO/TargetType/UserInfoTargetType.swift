//
//  UserInfoTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

enum UserInfoTargetType {
    case updateUserInfo(request: UserInfoRequest)
    case getUserUptime
}

extension UserInfoTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var path: String {
        switch self {
        case .updateUserInfo:
            return "\(utilPath.rawValue)/personal-info"
        case .getUserUptime:
            return "\(utilPath.rawValue)/personal-info/uptime"
        }
    }
    
    var method: Moya.Method {
        return .patch
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .updateUserInfo(let request):
            return request
        case .getUserUptime:
            return nil
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
