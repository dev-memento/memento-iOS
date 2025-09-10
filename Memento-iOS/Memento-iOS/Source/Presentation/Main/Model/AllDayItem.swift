//
//  AllDayItem.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/15/25.
//

import Foundation

struct AllDayItem {
    let id: Int
    let description: String
    let startDate: String
    let endDate: String
    let tagColorCode: String
    
    init(from response: AllDaySchedulesList) {
        self.id = response.id
        self.description = response.description
        self.startDate = response.startDate
        self.endDate = response.endDate
        self.tagColorCode = response.tagColorCode
    }
}
