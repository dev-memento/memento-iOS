//
//  PrioritizationTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/24/25.
//

import Foundation
import Moya

enum PrioritizationTargetType {
    case todo(request: PrioritizationRequest)
}

extension PrioritizationTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .todo
    }
    
    var path: String {
        switch self {
        case .todo:
            return "\(utilPath.rawValue)/prioritization/weekly"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .todo(let request):
            return request
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
