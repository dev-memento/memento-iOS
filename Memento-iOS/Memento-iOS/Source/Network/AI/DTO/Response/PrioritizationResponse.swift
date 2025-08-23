//
//  PrioritizationResponse.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/24/25.
//

import Foundation

struct PrioritizationResponse: Codable {
    let todos: [[ToDos]]
}

struct ToDos: Codable {
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
