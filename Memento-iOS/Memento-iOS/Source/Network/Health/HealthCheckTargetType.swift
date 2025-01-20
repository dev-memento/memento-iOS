//
//  HealthCheckTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/20/25.
//

import Foundation

import Moya

enum HealthCheckTargetType {
    case getHealthCheck
}

extension HealthCheckTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .health
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
        return utilPath.rawValue
    }
    
    var method: Moya.Method {
        return .get
    }
}
