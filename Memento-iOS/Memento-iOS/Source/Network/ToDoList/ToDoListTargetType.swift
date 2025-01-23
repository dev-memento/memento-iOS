//
//  ToDoListTargetType.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/23/25.
//

import Foundation

import Moya

enum ToDoListTargetType {
    case getToDoList
}

extension ToDoListTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .todo
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
