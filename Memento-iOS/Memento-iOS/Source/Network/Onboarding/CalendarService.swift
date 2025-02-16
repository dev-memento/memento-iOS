//
//  CalendarService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 2/16/25.
//

import Foundation
import EventKit

final class CalendarService {
    
    static let shared = CalendarService()
    private let store = EKEventStore()
    
    private init() {}
    
    /// 캘린더 접근 권한 요청
    func requestCalendarAccess() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch status {
        case .notDetermined:
            return try await store.requestFullAccessToEvents()
        case .authorized:
            return true
        default:
            return false
        }
    }
    
    /// 2년간의 캘린더 이벤트 가져오기
    func fetchEventsForTwoYears() async throws -> [EKEvent] {
        guard try await requestCalendarAccess() else {
            throw NSError(domain: "CalendarAccessError", code: 1, userInfo: [NSLocalizedDescriptionKey: "캘린더 접근 권한이 없습니다."])
        }
        
        let currentDate = Date()
        guard let startDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate),
              let endDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) else {
            throw NSError(domain: "DateCalculationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "날짜 계산에 실패했습니다."])
        }
        
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = store.events(matching: predicate)
        
        return events.sorted { $0.startDate < $1.startDate }
    }
    
    /// EKEvent를 AppleSchedule로 변환(메멘토 서버 저장 양식)
    static func convertToAppleSchedule(event: EKEvent) -> AppleSchedule {
        let dateFormatter = ISO8601DateFormatter()
        return AppleSchedule(
            description: event.title ?? "제목 없음",
            startDate: dateFormatter.string(from: event.startDate),
            endDate: dateFormatter.string(from: event.endDate),
            isAllDay: event.isAllDay
        )
    }
    
    /// 이벤트 목록 출력 (디버깅용)
    func printEvents(_ events: [EKEvent]) {
        guard !events.isEmpty else {
            print("[INFO] 이번 달에 등록된 일정이 없습니다.")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        for event in events {
            let startDate = formatter.string(from: event.startDate)
            let endDate = formatter.string(from: event.endDate)
            
            print("""
            --------------
            📌 제목: \(event.title ?? "제목 없음")
            🕒 시작: \(startDate)
            ⏳ 종료: \(endDate)
            📍 위치: \(event.location ?? "위치 정보 없음")
            👥 참석자: \(event.attendees?.map { $0.name ?? "참석자 없음" }.joined(separator: ", ") ?? "참석자 없음")
            🔔 알림: \(event.alarms?.map { $0.relativeOffset.description }.joined(separator: ", ") ?? "알림 없음")
            🔄 반복 여부: \(event.recurrenceRules != nil ? "반복 이벤트" : "단일 이벤트")
            🛏️ 올데이 여부: \(event.isAllDay ? "올데이 일정" : "시간 지정 일정")
            📝 노트: \(event.notes ?? "노트 없음")
            🌐 URL: \(event.url?.absoluteString ?? "URL 없음")
            --------------
            """)
        }
    }
}
