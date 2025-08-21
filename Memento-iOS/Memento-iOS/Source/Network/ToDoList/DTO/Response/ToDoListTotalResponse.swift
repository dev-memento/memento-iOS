//
//  ToDoListTotalResponse.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/23/25.
//

import Foundation

struct ToDoListTotalResponse: Codable {
    let toDoGetResponses: [ToDoGetResponses]
}

struct ToDoGetResponses: Codable, Equatable {
    let id: Int
    let groupId: String
    let description: String
    let startDate: String
    let endDate: String
    var isCompleted: Bool
    let priorityValue: Double
    let priorityType: String
    let tagName: String
    let tagColor: String
    let toDoType: String
    let orderNum: Double
}
