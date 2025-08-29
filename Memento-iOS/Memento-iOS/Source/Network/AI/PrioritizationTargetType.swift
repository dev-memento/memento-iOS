//
//  PrioritizationTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/24/25.
//

import Foundation

import Moya

enum PrioritizationTargetType {
    case fetchWeeklyPrioritization(body: PrioritizationRequest)
}

extension PrioritizationTargetType: BaseTargetType {
    
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .todo
    }
    
    var pathParameter: String? {
        return .none
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .fetchWeeklyPrioritization(let body):
            return body
        }
    }
    
    var path: String {
        switch self {
        case .fetchWeeklyPrioritization:
            return "\(utilPath.rawValue)/prioritization/weekly"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
}
