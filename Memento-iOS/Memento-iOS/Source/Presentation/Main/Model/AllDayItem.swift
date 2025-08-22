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
    let tagColorCode: String
    
    init(from response: AllDaySchedulesList) {
        self.id = response.id
        self.description = response.description
        self.tagColorCode = response.tagColorCode
    }
}
