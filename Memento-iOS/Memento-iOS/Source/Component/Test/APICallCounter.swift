//
//  APICallCounter.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 9/3/25.
//

import Foundation

// 전역 or 싱글톤으로 카운트 저장소
final class APICallLogger {
    static let shared = APICallLogger()
    private init() {}

    private var toDoTimes: [Double] = []
    private var scheduleTimes: [Double] = []

    // ToDo API 시간 기록
    func logToDoCall(start: Date) {
        let elapsed = Date().timeIntervalSince(start) * 1000
        toDoTimes.append(elapsed)
        print("📌 ToDo API 호출 #\(toDoTimes.count) — 응답 시간: \(String(format: "%.2f", elapsed))ms")
    }

    // Schedule API 시간 기록
    func logScheduleCall(start: Date) {
        let elapsed = Date().timeIntervalSince(start) * 1000
        scheduleTimes.append(elapsed)
        print("📌 Schedule API 호출 #\(scheduleTimes.count) — 응답 시간: \(String(format: "%.2f", elapsed))ms")
    }

    // 평균/최대/최소 값 리포트
    func report() {
        if !toDoTimes.isEmpty {
            let avg = toDoTimes.reduce(0,+) / Double(toDoTimes.count)
            let minVal = toDoTimes.min() ?? 0
            let maxVal = toDoTimes.max() ?? 0
            print("📊 ToDo API 통계 → 호출: \(toDoTimes.count), 평균: \(String(format: "%.2f", avg))ms, 최소: \(String(format: "%.2f", minVal))ms, 최대: \(String(format: "%.2f", maxVal))ms")
        }
        if !scheduleTimes.isEmpty {
            let avg = scheduleTimes.reduce(0,+) / Double(scheduleTimes.count)
            let minVal = scheduleTimes.min() ?? 0
            let maxVal = scheduleTimes.max() ?? 0
            print("📊 Schedule API 통계 → 호출: \(scheduleTimes.count), 평균: \(String(format: "%.2f", avg))ms, 최소: \(String(format: "%.2f", minVal))ms, 최대: \(String(format: "%.2f", maxVal))ms")
        }
    }

    // 데이터 초기화 (테스트 시 필요)
    func reset() {
        toDoTimes.removeAll()
        scheduleTimes.removeAll()
    }
}
