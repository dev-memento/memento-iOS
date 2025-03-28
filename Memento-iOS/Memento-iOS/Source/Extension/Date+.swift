//
//  Date+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// 특정 포맷의 날짜 문자열 반환
    func formattedDate(with format: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }

    /// ISO 8601 포맷 반환
    func makeCurrentDate() -> String {
        return self.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", timeZone: TimeZone(abbreviation: "UTC")!)
    }

    func roundedToNearestHalfHour() -> Date {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self)
        let components = calendar.dateComponents([.year, .month, .hour], from: self)

        guard let baseHour = calendar.date(from: components) else { return self }

        let roundedMinutes = (minute + 15) / 30 * 30

        return calendar.date(byAdding: .minute, value: roundedMinutes, to: baseHour) ?? self
    }

    /// 문자열 날짜를 특정 포맷 날짜로 반환
    static func dateFromString(_ dateString: String, format: String = "yyyy-MM-dd HH:mm:ss.SSSSSS") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: dateString)
    }

    /// Start Date와 End Date의 소요 시간 (Duration Time)을 계산해주는 메소드
    static func calculateDuration(startDate: String, endDate: String, format: String = "yyyy-MM-dd HH:mm:ss.SSSSSS") -> Int {
        guard let start = Date.dateFromString(startDate, format: format),
              let end = Date.dateFromString(endDate, format: format) else {
            // 변환 실패 시 기본값 반환
            return 0
        }
        
        // 초 단위 시간 차이 반환
        return Int(end.timeIntervalSince(start))
    }
    
    static func makeMonthDate(month: String) -> String {
        switch month {
        case "1":
            return "Jan"
        case "2":
            return "Feb"
        case "3":
            return "Mar"
        case "4":
            return "Apr"
        case "5":
            return "May"
        case "6":
            return "Jun"
        case "7":
            return "Jul"
        case "8":
            return "Aug"
        case "9":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            return ""
        }
    }
}
