//
//  ScheduleTotalResponseData.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

struct ScheduleTotalResponseData: Codable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let isAllDay: Bool
    let scheduleType: String
    let order: Int
    let tagName: String
    let tagColorCode: String
}
