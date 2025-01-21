//
//  DailyScheduleData.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

struct DailyScheduleData: Codable {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let durationTime: Int
    let tagColorCode: String
    let tagName: String
    let scheduleType: String
    
    init(id: Int, description: String, startDate: String, endDate: String, tagColorCode: String, tagName: String, scheduleType: String) {
        self.id = id
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.tagColorCode = tagColorCode
        self.tagName = tagName
        self.scheduleType = scheduleType
        self.durationTime = Date.calculateDuration(startDate: startDate, endDate: endDate)
    }
}
