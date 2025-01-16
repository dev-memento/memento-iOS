//
//  ToDoListDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

struct ToDoListDataModel: Identifiable {
    var id = UUID()
    var colorType: String
    var toDoTitle: String
    var dueDate: String
    var priorityType: Priority
    var isChecked: Bool
}
