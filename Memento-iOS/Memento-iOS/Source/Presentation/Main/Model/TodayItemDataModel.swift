//
//  TodayItemDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

enum TodayItemDataModel: Identifiable, Equatable {
    case todo(ToDoListDataModel)
    case schedule(ScheduleListDataModel)
    
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
    var toDoBinding: ToDoListDataModel {
        get {
            if case .todo(let todo) = self {
                return todo
            } else {
                fatalError("not To Do case")
            }
        }
        set {
            if case .todo = self {
                self = .todo(newValue)
            }
        }
    }
}
