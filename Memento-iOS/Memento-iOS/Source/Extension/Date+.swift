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
    
    var endOfDay: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
    }
    
    /// Date → String 변환
    func stringFromDate(with format: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from: self)
    }
    
    /// String → Date 변환
    static func dateFromString(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.date(from: dateString)
    }
    
    /// ToDoListView 에서 month를 영문 약어로 변환
    static func makeMonthDate(month: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        guard let date = formatter.date(from: month) else { return "" }
        
        formatter.dateFormat = "MMM"
        
        return formatter.string(from: date)
    }
    
    /// 현재 시간을 기준으로 가장 가까운 30분 단위로 반올림한 시간을 반환
    func roundedToNearestHalfHour() -> Date {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self)
        let components = calendar.dateComponents([.year, .month, .hour], from: self)
        
        guard let baseHour = calendar.date(from: components) else { return self }
        
        let roundedMinutes = (minute + 15) / 30 * 30
        
        return calendar.date(byAdding: .minute, value: roundedMinutes, to: baseHour) ?? self
    }
    
    /// ToDoListCell, ToDoAlertView 에서 endDate가 오늘 날짜면 "Today"를 반환하고,
    /// 오늘이 아니면 "MMM dd, YYYY" 형식의 문자열로 변환
    static func displayEndDate(_ endDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: endDate) {
            if Calendar.current.isDate(date, inSameDayAs: Date()) {
                return "Today"
            }
            return date.stringFromDate(with: "MMM dd, YYYY")
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
