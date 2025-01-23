//
//  TagTargetType.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/23/25.
//

import Foundation

import Moya

enum TagTargetType {
    case getTags
}

extension TagTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .tag
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
