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
    case deleteTag(Int)
    case patchTag(Int, TagPostRequest)
}

extension TagTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .tag
    }
    
    var pathParameter: String? {
        switch self {
        case .getTags, .postTag:
            return .none
        case .deleteTag(let tagId), .patchTag(let tagId, _):
            return "\(tagId)"
        }
    }
    
    var queryParameter: [String: Any]? {
        return .none
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .getTags, .deleteTag:
            return nil
        case .postTag(let request), .patchTag(_, let request):
            return request
        }
    }
    
    var path: String {
        switch self {
        case .getTags, .postTag:
            return utilPath.rawValue
        case .deleteTag(let tagId), .patchTag(let tagId, _):
            return "\(utilPath.rawValue)/\(tagId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTags:
            return .get
        case .postTag:
            return .post
        case .deleteTag:
            return .delete
        case .patchTag:
            return .patch
        }
    }
}
