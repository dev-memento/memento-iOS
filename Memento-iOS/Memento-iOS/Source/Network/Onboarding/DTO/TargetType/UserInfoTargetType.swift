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
    case updateUserUptime(request: UserUptimeRequest)
    case updateUserTimezone(request: UserTimezoneRequest)
}

extension UserInfoTargetType: BaseTargetType {
    
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var pathParameter: String? {
        return nil
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
        case .updateUserUptime:
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
    
    var requestBodyParameter: Codable? {
        switch self {
        case .updateUserInfo(let request):
            return request
        case .updateUserUptime(let request):
            return request
        case .updateUserTimezone(let request):
            return request
        case .getUserUptime:
            return nil
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
