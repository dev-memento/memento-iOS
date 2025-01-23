//
//  ScheduleAllDayResponseData.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

struct ScheduleAllDayResponseData: Codable, Equatable {
    let data: [ScheduleAllDayResponseDataTest]
}

struct ScheduleAllDayResponseDataTest: Codable, Equatable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
    let scheduleType: String
    let tagName: String
    let tagColorCode: String
}
