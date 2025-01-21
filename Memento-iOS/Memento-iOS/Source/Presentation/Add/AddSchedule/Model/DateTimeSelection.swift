//
//  DateTimeSelection.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

struct DateTimeSelection: Equatable {
    var startsDate: Date
    var endsDate: Date
    var isAllDay: Bool
    var selectedStartTime: Date
    var selectedEndTime: Date
}
