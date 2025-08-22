//
//  TodayItem.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

enum TodayItem: Identifiable, Equatable {
    
    case todo(ToDoItem)
    case schedule(ScheduleItem)
    
    // `Identifiable`을 준수하기 위해 고유 id 추가
    var id: Int {
        switch self {
        case .todo(let todo):
            return todo.id
        case .schedule(let schedule):
            return schedule.id
        }
    }
}
