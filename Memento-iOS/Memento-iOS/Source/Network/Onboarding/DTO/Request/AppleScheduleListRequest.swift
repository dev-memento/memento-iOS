//
//  AppleScheduleListRequest.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation

struct AppleScheduleListRequest: Codable {
    let events: [AppleSchedule]
}

struct AppleSchedule: Codable {
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
}
