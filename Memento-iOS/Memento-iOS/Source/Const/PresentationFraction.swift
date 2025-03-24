//
//  PresentationFraction.swift
//  Memento-iOS
//
//  Created by RAFA on 3/23/25.
//

import Foundation

enum PresentationFraction {

    enum AddTodo {
        enum Date {
            static let small : CGFloat = 0.65
            static let medium: CGFloat = 0.56
            static let large : CGFloat = 0.52
        }

        enum Priority {
            static let small : CGFloat = 0.83
            static let medium: CGFloat = 0.8
            static let large : CGFloat = 0.8
        }
    }

    enum AddSchedule {
        enum Date {
            static let small : CGFloat = 0.65
            static let medium: CGFloat = 0.56
            static let large : CGFloat = 0.52
        }

        enum Time {
            static let small : CGFloat = 0.43
            static let medium: CGFloat = 0.37
            static let large : CGFloat = 0.33
        }
    }
}

typealias AddTodoDateFraction     = PresentationFraction.AddTodo.Date
typealias AddTodoPriorityFraction = PresentationFraction.AddTodo.Priority

typealias AddScheduleDateFraction = PresentationFraction.AddSchedule.Date
typealias AddScheduleTimeFraction = PresentationFraction.AddSchedule.Time
