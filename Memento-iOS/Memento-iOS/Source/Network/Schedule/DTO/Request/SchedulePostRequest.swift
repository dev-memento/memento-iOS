//
//  SchedulePostRequest.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/19/25.
//

import Foundation

struct SchedulePostRequest: Codable {
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
    let tagId: Int
}
