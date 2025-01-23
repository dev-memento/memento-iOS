//
//  TodoTargetType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import Moya

enum TodoTargetType {
    case createTodo(
        startDate: String,
        description: String,
        endDate: String?,
        tagId: Int?,
        priorityUrgency: Double?,
        priorityImportance: Double?
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
        return utilPath.rawValue
    }

    var method: Moya.Method {
        return .post
    }

    var requestBodyParameter: Codable? {
        switch self {
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
