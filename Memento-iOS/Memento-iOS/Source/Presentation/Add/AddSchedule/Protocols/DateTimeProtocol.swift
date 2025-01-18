//
//  DateTimeProtocol.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

protocol DateTimeFormatterProtocol {
    func formatDate(_ date: Date, format: String, locale: Locale) -> String
}

protocol DateTimeValidatorProtocol {
    func validateDateRange(start: Date, end: Date) -> Bool
    func adjustToStartOfDay(_ date: Date) -> Date
}
