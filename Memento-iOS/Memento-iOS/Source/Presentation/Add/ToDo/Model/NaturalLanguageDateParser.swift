//
//  NaturalLanguageDateParser.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/29/25.
//

import Foundation

struct ParsedDateResult {
    let title: String
    let startDate: Date?
    let endDate: Date?
}

final class NaturalLanguageDateParser {
    static let shared = NaturalLanguageDateParser()
    private init() {}
    
    // MARK: - Regex Patterns
    
    private let timeRangeRegex = try! NSRegularExpression(
        pattern: "(오전|오후)?\\s?(\\d{1,2})시부터\\s?(오전|오후)?\\s?(\\d{1,2})시까지"
    )
    private let dateRangeRegex = try! NSRegularExpression(
        pattern: "(?:([\\s\\S]+?)부터)?\\s*([\\s\\S]+?)까지"
    )
    private let korDateRegex = try! NSRegularExpression(
        pattern: "(어제|그제|오늘|내일|모레|(\\d+)일\\s*(전|후)|\\d{1,2}월\\s*\\d{1,2}일|\\d{1,2}/\\d{1,2})"
    )
    private let korWeekdayRegex = try! NSRegularExpression(pattern: "(이번주|다음주)?\\s*(일|월|화|수|목|금|토)요일?")
    private let weekDaysKor: [String: Int] = ["일": 1, "월": 2, "화": 3, "수": 4, "목": 5, "금": 6, "토": 7]
    
    // MARK: - Main Parser
    
    func parse(_ input: String, parseTime: Bool = true) -> ParsedDateResult {
        let now = Date()
        let calendar = Calendar.current
        var text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var startDate: Date?
        var endDate: Date?
        
        // 1. 시간 범위 처리 (오후 3시부터 오후 5시까지)
        if parseTime, let match = firstMatch(for: timeRangeRegex, in: text) {
            let sm = match[1], sh = match[2], em = match[3], eh = match[4]
            let startHour = adjustTo24Hour(hour: Int(sh) ?? 0, meridiem: sm)
            let endHour = adjustTo24Hour(hour: Int(eh) ?? 0, meridiem: em)
            
            let baseStart = startDate ?? now
            let baseEnd = endDate ?? startDate ?? now
            
            startDate = calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: baseStart)
            endDate = calendar.date(bySettingHour: endHour, minute: 0, second: 0, of: baseEnd)
            text = text.replacingOccurrences(of: match.value, with: "")
        }
        
        // 2. 날짜 범위 처리 (오늘부터 내일까지 / 5일부터 8일까지 / 내일까지)
        if let match = firstMatch(for: dateRangeRegex, in: text) {
            let fromExpr = match[1].trimmingCharacters(in: .whitespaces)
            let toExpr = match[2].trimmingCharacters(in: .whitespaces)
            
            startDate = fromExpr.isEmpty ? now.startOfDay : parseDateOnly(fromExpr, now: now)
            endDate = parseDateOnly(toExpr, now: now)
            text = text.replacingOccurrences(of: match.value, with: "")
        }
        
        // 3. 한국어 요일 처리 (이번주 금요일 / 다음주 토요일)
        if startDate == nil, let match = firstMatch(for: korWeekdayRegex, in: text) {
            let weekCtx = match[1]
            let dayKor = match[2]
            
            if let weekday = weekDaysKor[dayKor] {
                let todayWeekday = calendar.component(.weekday, from: now)
                let weekOffset = (weekCtx == "다음주") ? 7 : 0
                var dayDiff = weekday - todayWeekday
                if dayDiff < 0 { dayDiff += 7 }
                dayDiff += weekOffset
                
                let targetDate = calendar.date(byAdding: .day, value: dayDiff, to: now.startOfDay)!
                startDate = targetDate
                endDate = targetDate
            }
            text = text.replacingOccurrences(of: match.value, with: "")
        }
        
        // 4. 단일 날짜 처리 (parseDateOnly 활용)
        if let match = firstMatch(for: korDateRegex, in: text) {
            let expr = match.value.trimmingCharacters(in: .whitespaces)
            let parsed = parseDateOnly(expr, now: now)
            if startDate == nil { startDate = parsed }
            if endDate == nil { endDate = parsed }
            text = text.replacingOccurrences(of: match.value, with: "")
        }
        
        let remainTitle = text.isEmpty ? input : text
        return ParsedDateResult(title: remainTitle, startDate: startDate, endDate: endDate)
    }
    
    // MARK: - Date Parsing
    
    private func parseDateOnly(_ expr: String, now: Date) -> Date {
        let lower = expr.lowercased()
        let calendar = Calendar.current
        
        switch lower {
        case "오늘": return now.startOfDay
        case "내일": return calendar.date(byAdding: .day, value: 1, to: now.startOfDay)!
        case "모레": return calendar.date(byAdding: .day, value: 2, to: now.startOfDay)!
        case "어제": return calendar.date(byAdding: .day, value: -1, to: now.startOfDay)!
        case "그제": return calendar.date(byAdding: .day, value: -2, to: now.startOfDay)!
        default: break
        }
        
        // "3일 후" / "2일 전"
        if let match = firstMatch(for: korDateRegex, in: expr), !match[2].isEmpty, !match[3].isEmpty {
            let days = Int(match[2]) ?? 0
            let dir = match[3] == "후" ? 1 : -1
            return calendar.date(byAdding: .day, value: days * dir, to: now.startOfDay)!
        }
        
        // "3월 27일"
        let monthDayRegex = try! NSRegularExpression(pattern: "(\\d{1,2})월\\s*(\\d{1,2})일")
        if let md = firstMatch(for: monthDayRegex, in: expr) {
            let month = Int(md[1]) ?? calendar.component(.month, from: now)
            let day = Int(md[2]) ?? calendar.component(.day, from: now)
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.month = month
            components.day = day
            return calendar.date(from: components) ?? now.startOfDay
        }
        
        // "3/27"
        let mdSlashRegex = try! NSRegularExpression(pattern: "(\\d{1,2})/(\\d{1,2})(?:/(\\d{4}))?")
        if let md = firstMatch(for: mdSlashRegex, in: expr) {
            let month = Int(md[1]) ?? calendar.component(.month, from: now)
            let day = Int(md[2]) ?? calendar.component(.day, from: now)
            let year = Int(md[3]) ?? calendar.component(.year, from: now)
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            return calendar.date(from: components) ?? now.startOfDay
        }
        
        return now.startOfDay
    }
    
    // MARK: - Helper
    
    private func firstMatch(for regex: NSRegularExpression, in text: String) -> NSTextCheckingResultWithValue? {
        guard let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)) else { return nil }
        var results: [String] = []
        for i in 0..<match.numberOfRanges {
            if let range = Range(match.range(at: i), in: text) {
                results.append(String(text[range]))
            } else {
                results.append("")
            }
        }
        return NSTextCheckingResultWithValue(value: results[0], groups: results)
    }
    
    private func adjustTo24Hour(hour: Int, meridiem: String?) -> Int {
        switch meridiem {
        case "오전": return hour == 12 ? 0 : hour
        case "오후": return hour < 12 ? hour + 12 : hour
        default: return hour
        }
    }
}

struct NSTextCheckingResultWithValue {
    let value: String
    let groups: [String]
    subscript(index: Int) -> String {
        return groups.count > index ? groups[index] : ""
    }
}
