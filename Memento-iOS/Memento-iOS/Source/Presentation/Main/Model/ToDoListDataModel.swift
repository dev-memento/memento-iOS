//
//  ToDoListDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

struct ToDoListDataModel: Identifiable, Equatable, Hashable {
    var id: Int
    var colorType: String
    var toDoTitle: String
    var date: String
    var dueDate: String
    var priorityType: Priority
    var isChecked: Bool
    var tagName: String
    
    func mapToToDoItem() -> ToDoListTotalResponseDataTest {
        return .init(id: id,
                     groupId: "",
                     description: toDoTitle,
                     startDate: date,
                     endDate: dueDate,
                     isCompleted: false,
                     priorityValue: 1,
                     priorityType: priorityType.title,
                     tagName: tagName,
                     tagColor: colorType,
                     toDoType: "",
                     orderNum: 0)
    }
}
