//
//  PickerButtonType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

enum PickerButtonType {
    case addSchedule(AddSchedulePickerButtonType)
    case addToDo(AddToDoPickerButtonType)
}

enum AddSchedulePickerButtonType {
    case date(DateTimeType)
    case time(DateTimeType)
    case tag
}

enum DateTimeType {
    case start, end
}

enum AddToDoPickerButtonType {
    case date, tag, priority
}
