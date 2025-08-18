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
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        guard let date = formatter.date(from: month) else { return "" }
        
        formatter.dateFormat = "MMM"
        
        return formatter.string(from: date)
    }
    
    static func formatEndDate(_ endDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: endDate) {
            if Calendar.current.isDate(date, inSameDayAs: Date()) {
                return "Today"
            }
            dateFormatter.dateFormat = "MMM dd"
            return dateFormatter.string(from: date)
        }
        
        return endDate
    }
    
    /// ScheduleListCell 에서 endDate와 현재 시간을 비교하여 스케줄이 종료되었는지 여부를 반환
    static func hasScheduleEnded(endDate: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone.current
        guard let date = formatter.date(from: endDate) else {
            return false
        }
        return Date() > date
    }
}
