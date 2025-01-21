//
//  ScheduleAllDayResponseData.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

struct ScheduleAllDayResponseData: Codable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
    let scheduleType: String
    let tagName: String
    let tagColor: String
}
