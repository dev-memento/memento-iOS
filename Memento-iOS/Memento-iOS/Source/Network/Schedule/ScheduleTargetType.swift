//
//  ScheduleTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

import Moya

enum ScheduleTargetType {
    case getSchedulesTotal // 전체 일정 조회
    case getSchedulesAllDay // All day 일정 조회
    case getSchedulesByDate(date: String) // 특정 날짜 일정 조회
    
    case postSchedule(body: SchedulePostRequest) // 일정 생성
    
    case deleteSchedule(scheduleId: Int) // 일정 삭제
    
    case updateSchedule(scheduleId: Int, body: SchedulePostRequest) // 일정 수정
}

extension ScheduleTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .schedule
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        switch self {
        case .getSchedulesByDate(let date):
            return ["date": date]
        default:
            return nil
        }
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postSchedule(let body):
            return body
        case .updateSchedule(_, let body):
            return body
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getSchedulesTotal:
            return utilPath.rawValue + "/total"
        case .getSchedulesAllDay:
            return utilPath.rawValue + "/all-days"
        case .deleteSchedule(let scheduleId),
                .updateSchedule(let scheduleId, _):
            return utilPath.rawValue + "/\(scheduleId)"
        default:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSchedule:
            return .post
        case .deleteSchedule:
            return .delete
        case .updateSchedule:
            return .patch
        default:
            return .get
        }
    }
}
