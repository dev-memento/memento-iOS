//
//  ToDoListTargetType.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/23/25.
//

import Foundation

import Moya

enum ToDoListTargetType {
    case getToDoListTotal // 전체 투두리스트 조회
    case getToDoByDate(date: String) // 특정 날짜 투두 조회
    case getToDoDetail(toDoId: Int) // 투두 상세 조회
    
    case postToDo(body: ToDoPostRequest) // 투두 생성
    
    case deleteToDo(todoId: Int) // 투두 삭제
    
    case updateToDoCompletion(toDoId: Int) // 투두 완료 업데이트
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
        switch self {
        case .getToDoByDate(let date):
            return ["date": date]
        default:
            return nil
        }
    }
    
    var requestBodyParameter: Codable? {
        switch self {
        case .postToDo(let body):
            return body
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .updateToDoCompletion(let toDoId):
            return "\(utilPath.rawValue)/\(toDoId)/completion"
        case .getToDoDetail(let toDoId),
                .deleteToDo(let toDoId):
            return "\(utilPath.rawValue)/\(toDoId)"
        case .getToDoByDate(let date):
            return "\(utilPath.rawValue)/date"
        default:
            return utilPath.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postToDo:
            return .post
        case .updateToDoCompletion:
            return .patch
        case .deleteToDo:
            return .delete
        default:
            return .get
        }
    }
}
