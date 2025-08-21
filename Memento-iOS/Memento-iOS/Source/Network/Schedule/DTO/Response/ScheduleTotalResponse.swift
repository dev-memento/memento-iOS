//
//  ScheduleTotalResponse.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

struct ScheduleTotalResponse: Codable, Equatable {
    let scheduleWithOrderInfos: [ScheduleWithOrderInfos]
}

struct ScheduleWithOrderInfos: Codable, Equatable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let timeDuration: String
    let isAllDay: Bool
    let scheduleType: String
    let order: Int
    let tagName: String
    let tagColorCode: String
}
