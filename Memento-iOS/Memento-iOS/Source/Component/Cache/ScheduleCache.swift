//
//  ScheduleCache.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 9/3/25.
//

import Foundation

final class ScheduleCache {
    static let shared = ScheduleCache()
    private init() {}

    // 캐시 저장소 (key: String → (데이터, 저장된 시각))
    private var cache: [String: (data: [ScheduleItem], timestamp: Date)] = [:]
    private let ttl: TimeInterval = 300 // 5분 캐시

    /// 캐시 조회
    func get(key: String) -> [ScheduleItem]? {
        guard let entry = cache[key] else { return nil }
        // TTL 이내면 캐시 데이터 반환, 아니면 nil
        if Date().timeIntervalSince(entry.timestamp) < ttl {
            return entry.data
        }
        return nil
    }

    /// 캐시 저장
    func set(key: String, data: [ScheduleItem]) {
        cache[key] = (data, Date())
    }

    /// 캐시 초기화 (테스트용)
    func reset() {
        cache.removeAll()
    }
}
