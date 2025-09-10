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

    // 캐시 저장소 (key: String → 데이터)
    private var cache: [String: [ScheduleItem]] = [:]

    /// 캐시 조회
    func get(key: String) -> [ScheduleItem]? {
        return cache[key]
    }

    /// 캐시 저장
    func set(key: String, data: [ScheduleItem]) {
        cache[key] = data
    }
}

