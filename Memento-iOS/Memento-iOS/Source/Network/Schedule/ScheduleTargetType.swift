//
//  ScheduleTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

import Moya

enum ScheduleTargetType {
    case getSchedulesTotal
    case getSchedulesAllDay
    case getSchedules
    case getSchedulesDetail
}

extension ScheduleTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .schedule
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        return .none
    }
    
    var requestBodyParameter: Codable? {
        return nil
    }
    
    var path: String {
        switch self {
        case .getSchedulesTotal:
            return utilPath.rawValue + "/total"
        case .getSchedulesAllDay:
            return utilPath.rawValue + "/all-days"
        default:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        return .get
    }
}
