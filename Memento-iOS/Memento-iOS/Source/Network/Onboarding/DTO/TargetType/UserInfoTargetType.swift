//
//  UserInfoTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

import Foundation

enum UserInfoTargetType {
    case user(request: UserInfoRequest) // 서버로 던질거 정의
}

extension UserInfoTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .user
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(utilPath.rawValue)/personal-info"
        }
    }
    
    var method: Moya.Method {
        return .patch
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .user(let request):
            return request // 수정된 부분
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
