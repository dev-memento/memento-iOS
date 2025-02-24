//
//  PickerButtonType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

enum AddTodoPickerButtonType {
    case date, tag, priority
}

enum AddSchedulePickerButtonType {
    case date, time, tag
}

enum PickerButtonType {
    case addTodo(AddTodoPickerButtonType)
    case addSchedule(AddSchedulePickerButtonType)
}
