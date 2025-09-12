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
    case postTag(TagPostRequest)
}

extension TagTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .tokenHeader
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
        switch self {
        case .getTags:
            return nil
        case .postTag(let request):
            return request
        }
    }
    
    var path: String {
        return utilPath.rawValue
    }
    
    var method: Moya.Method {
        switch self {
        case .getTags:
            return .get
        case .postTag:
            return .post
        }
    }
}
