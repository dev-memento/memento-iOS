//
//  AppleSchedulesTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

import Foundation

enum AppleSchedulesTargetType {
    case schedule(request: AppleScheduleListRequest)
}

extension AppleSchedulesTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .schedule
    }
    
    var path: String {
        switch self {
        case .schedule:
            return "\(utilPath.rawValue)/apple"
        }
    }
    
    var method: Moya.Method {
        return .patch
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .schedule(let request):
            return request 
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
