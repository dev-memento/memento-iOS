//
//  ScheduleAllDayResponse.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

struct ScheduleAllDayResponse: Codable, Equatable {
    let allDaySchedulesList: [AllDaySchedulesList]
}

struct AllDaySchedulesList: Codable, Equatable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
    let scheduleType: String
    let tagName: String
    let tagColorCode: String
}
