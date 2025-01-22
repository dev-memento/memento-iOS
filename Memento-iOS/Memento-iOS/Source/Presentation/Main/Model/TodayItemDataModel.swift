//
//  TodayItemDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

enum TodayItemDataModel: Identifiable {
    case todo(ToDoListDataModel)
    case schedule(ScheduleTotalResponseData)
    
    var id: Int {
        switch self {
        case .todo(let todo):
            return todo.id.hashValue
        case .schedule(let schedule):
            return schedule.id
        }
    }
}

//extension TodayItemDataModel {
//    var toDoBinding: ToDoListDataModel {
//        if case .todo(let todo) = self {
//            return todo
//        } else {
//            fatalError("not To Do case")
//        }
//    }
//    
//    var scheduleBinding: ScheduleTotalResponseData {
//        if case .schedule(let schedule) = self {
//            return schedule
//        } else {
//            fatalError("not Schedule case")
//        }
//    }
//}

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


extension TodayItemDataModel: Equatable {
    static func == (lhs: TodayItemDataModel, rhs: TodayItemDataModel) -> Bool {
        switch (lhs, rhs) {
        case (.todo(let lhsTodo), .todo(let rhsTodo)):
            return lhsTodo == rhsTodo
        case (.schedule(let lhsSchedule), .schedule(let rhsSchedule)):
            return lhsSchedule == rhsSchedule
        default:
            return false
        }
    }
}
