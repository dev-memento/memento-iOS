//
//  ToDoDetailResponse.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/19/25.
//

import Foundation

struct ToDoDetailResponse: Codable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let isCompleted: Bool
    let priorityType: String
    let tagId: Int
    let tagName: String
    let tagColor: String
    let toDoType: String
}
