//
//  ScheduleItem.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

struct ScheduleItem: Identifiable, Equatable, Hashable {
    var id: Int
    var description: String
    let startDate: String
    let endDate: String
    let timeDuration: String
    let isAllDay: Bool
    let scheduleType: String
    let tagName: String
    let tagColorCode: String
    
    
    init(from response: ScheduleWithOrderInfos) {
        self.id = response.id
        self.description = response.description
        self.startDate = response.startDate
        self.endDate = response.endDate
        self.timeDuration = response.timeDuration
        self.isAllDay = response.isAllDay
        self.scheduleType = response.scheduleType
        self.tagName = response.tagName
        self.tagColorCode = response.tagColorCode
    }
}
