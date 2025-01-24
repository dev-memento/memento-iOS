//
//  TodayItemDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

enum TodayItemDataModel: Identifiable, Equatable {
    case todo(ToDoListDataModel)
    case schedule(ScheduleTotalResponseDataTest)
    
    // `Identifiable`을 준수하기 위해 고유 id 추가
    var id: Int {
        switch self {
        case .todo(let todo):
            return todo.id
        case .schedule(let schedule):
            return schedule.id
        }
    }
    
    // `toDoBinding`에 getter와 setter 추가
    var toDoBinding: ToDoListDataModel {
        get {
            if case .todo(let todo) = self {
                return todo
            } else {
                fatalError("not ToDo case")
            }
        }
        set {
            if case .todo = self {
                self = .todo(newValue)
            }
        }
    }
}

extension TodayItemDataModel {
    func mapToToDoResponse() -> ToDoListTotalResponseDataTest? {
        switch self {
        case .todo(let todo):
            return todo.mapToToDoItem()
        case .schedule:
            return nil
        }
    }
}
