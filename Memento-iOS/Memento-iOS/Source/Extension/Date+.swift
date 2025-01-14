//
//  Date+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import Foundation

extension Date {
    /// 특정 포맷의 날짜 문자열 반환
    func formattedDate(with format: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }

    /// ISO 8601 포맷 반환
    func makeCurrentDate() -> String {
        return self.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", timeZone: TimeZone(abbreviation: "UTC")!)
    }
}
