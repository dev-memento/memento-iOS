//
//  ToDoListResponseData.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/23/25.
//

struct ToDoListResponseData: Codable {
    let id: Int
    let groupId: String
    let description: String
    let startDate: String
    let endDate: String
    let isCompleted: Bool
    let priorityValue: Int
    let priorityType: String
    let tagName: String
    let tagColor: String
    let toDoType: String
    let orderNum: Int
}
