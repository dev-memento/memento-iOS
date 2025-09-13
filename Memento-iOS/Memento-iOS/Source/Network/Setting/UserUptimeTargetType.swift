//
//  UserUptimeTargetType.swift
//  Memento-iOS
//
//  Created by 이세민 on 9/13/25.
//

import Foundation

import Moya

enum UserUptimeTargetType {
    case getUserUptime
    case updateUserUptime(body: UserUptimeRequest)
    case updateUserTimezone(body: UserTimezoneRequest)
}

extension UserUptimeTargetType: BaseTargetType {
    
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var pathParameter: String? {
        return nil
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .updateUserUptime(let body):
            return body
        case .updateUserTimezone(let body):
            return body
        case .getUserUptime:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getUserUptime, .updateUserUptime:
            return "\(utilPath.rawValue)/personal-info/uptime"
        case .updateUserTimezone:
            return "\(utilPath.rawValue)/personal-info/timezone"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserUptime:
            return .get
        default:
            return .patch
        }
    }
}
