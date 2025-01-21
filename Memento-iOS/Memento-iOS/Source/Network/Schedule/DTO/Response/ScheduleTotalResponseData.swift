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
    let repeatOption: String
    let repeatExpiredDate: String?
    let scheduleGroupId: String
    let scheduleType: String
    let tagName: String
    let tagColor: String
    let order: Int
}
