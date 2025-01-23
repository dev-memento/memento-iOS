//
//  ToDoListDataModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

struct ToDoListDataModel: Identifiable, Equatable, Hashable {
    var id = Int()
    var colorType: String
    var toDoTitle: String
    var dueDate: String
    var priorityType: Priority
    var isChecked: Bool
    
    func mapToToDoItem() -> ToDoListTotalResponseDataTest {
        return .init(id: id,
                     groupId: "",
                     description: "",
                     startDate: "",
                     endDate: "",
                     isCompleted: false,
                     priorityValue: 1,
                     priorityType: priorityType.title,
                     tagName: "",
                     tagColor: colorType,
                     toDoType: "",
                     orderNum: 0)
    }
}
