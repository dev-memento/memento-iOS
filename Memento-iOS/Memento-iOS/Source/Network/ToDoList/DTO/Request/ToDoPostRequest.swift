//
//  ToDoPostRequest.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import Foundation

struct ToDoPostRequest: Codable {
    let startDate: String
    let description: String
    let endDate: String
    let tagId: Int
    let priorityUrgency: Double?
    let priorityImportance: Double?
}
