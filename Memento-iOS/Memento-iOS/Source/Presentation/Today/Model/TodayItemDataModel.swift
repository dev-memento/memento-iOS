//
//  TodayItemDataModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

enum TodayItemDataModel: Identifiable {
    
    case todo(TodoDataModel)
    case schedule(ScheduleDataModel)
    
    var id: UUID {
        switch self {
        case .todo(let todo):
            return todo.id
        case .schedule(let schedule):
            return schedule.id
        }
    }
}

extension TodayItemDataModel {
    var todoBinding: TodoDataModel {
        get {
            if case .todo(let todo) = self {
                return todo
            } else {
                fatalError("Todo 케이스가 아닙니다")
            }
        }
        set {
            if case .todo = self {
                self = .todo(newValue)
            }
        }
    }
}
