//
//  TodoTargetType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import Moya

enum TodoTargetType {
    case deleteTodo(todoId: Int)
    case createTodo(
        startDate: String,
        description: String,
        endDate: String,
        tagId: Int,
        priorityUrgency: Double,
        priorityImportance: Double
    )
}

extension TodoTargetType: BaseTargetType {
    
    var pathParameter: String? {
        return nil
    }
    
    var headerType: HeaderType {
        return .accessTokenHeader
    }
    
    var utilPath: UtilPath {
        return .todo
    }
    
    var path: String {
        switch self {
        case .deleteTodo(let todoId):
            return "\(utilPath.rawValue)/\(todoId)"
        case .createTodo:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteTodo:
            return .delete
        case .createTodo:
            return .post
        }
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .deleteTodo:
            return nil
        case .createTodo(
            let startDate,
            let description,
            let endDate,
            let tagId,
            let priorityUrgency,
            let priorityImportance
        ):
            return TodoRequest(
                startDate: startDate,
                description: description,
                endDate: endDate,
                tagId: tagId,
                priorityUrgency: priorityUrgency,
                priorityImportance: priorityImportance
            )
        }
    }
    
    var queryParameter: [String: Any]? {
        return nil
    }
}
