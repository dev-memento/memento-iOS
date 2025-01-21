//
//  DailyScheduleData.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

struct DailyScheduleData: Codable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let durationTime: Int
    let tagColor: String
    let tagName: String
    let scheduleType: String
}
