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
    case updateToDoCompletion(toDoId: Int)
}

extension ToDoListTargetType: BaseTargetType {
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .todo
    }
    
    var pathParameter: String? {
        switch self {
        case .updateToDoCompletion(let toDoId):
            return "/\(toDoId)/completion"
        default:
            return nil
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
    
    var requestBodyParameter: Codable? {
        return nil
    }
    
    var path: String {
        switch self {
        case .getToDoList:
            return utilPath.rawValue
        case .updateToDoCompletion:
            return "\(utilPath.rawValue)\(pathParameter ?? "")"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getToDoList:
            return .get
        case .updateToDoCompletion:
            return .patch
        }
    }
}
