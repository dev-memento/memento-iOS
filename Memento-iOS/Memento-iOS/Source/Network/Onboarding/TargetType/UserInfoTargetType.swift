//
//  UserInfoTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

enum UserInfoTargetType {
    case updateUserInfo(body: UserInfoRequest)
}

extension UserInfoTargetType: BaseTargetType {
    
    var headerType: HeaderType {
        return .tokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var pathParameter: String? {
        return nil
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
    
    var requestBodyParameter: Codable? {
        if case .updateUserInfo(let body) = self {
            return body
        }
        return nil
    }
    
    var path: String {
        return "\(utilPath.rawValue)/personal-info"
    }
    
    var method: Moya.Method {
        return .patch
    }
}
