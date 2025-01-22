//
//  LoginTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation
import Moya

enum LoginTargetType {
    case login(provider: String, idToken: String)
}

extension LoginTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .noTokenHeader
    }
    
    var utilPath: UtilPath {
        return .auth
    }
    
    var path: String {
        switch self {
        case .login:
            return "\(utilPath.rawValue)/login" // 결과: "/api/v1/auth/login"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .login(let provider, let idToken):
            return LoginRequest(provider: provider, idToken: idToken)
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
