//
//  UserUptimeTargetType.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

enum UserUptimeTargetType {
    case user // 서버로 GET 요청
}

extension UserUptimeTargetType: BaseTargetType {
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
            return "\(utilPath.rawValue)/personal-info/uptime"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var requestBodyParameter: Codable? {
        return nil 
    }

    var queryParameter: [String: Any]? {
        return nil
    }
}
