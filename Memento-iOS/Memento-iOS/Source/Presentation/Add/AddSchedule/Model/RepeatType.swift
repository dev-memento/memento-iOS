//
//  RepeatType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

enum RepeatType: CaseIterable {
    case none, everyDay, everyWeek, everyMonth, everyYear

    var title: String {
        switch self {
        case .none: return "None"
        case .everyDay: return "Every Day"
        case .everyWeek: return "Every Week"
        case .everyMonth: return "Every Month"
        case .everyYear: return "Every Year"
        }
    }
}
