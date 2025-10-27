//
//  ToDoItem.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import Foundation

struct ToDoItem: Identifiable, Equatable, Hashable {
    var id: Int
    var description: String
    var startDate: String
    var endDate: String
    var isCompleted: Bool
    var priorityType: Priority
    var tagName: String
    var tagColor: String
    var toDoType: String
    
    var completedAt: Date?
    
    init(from response: ToDoGetResponses) {
        self.id = response.id
        self.description = response.description
        self.startDate = response.startDate
        self.endDate = response.endDate
        self.isCompleted = response.isCompleted
        self.priorityType = Priority(rawValue: response.priorityType.lowercased()) ?? .none
        self.tagName = response.tagName
        self.tagColor = response.tagColor
        self.toDoType = response.toDoType
    }
}
