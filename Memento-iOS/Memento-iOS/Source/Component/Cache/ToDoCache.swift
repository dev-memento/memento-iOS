//
//  ToDoCache.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 9/3/25.
//

import Foundation

final class ToDoCache {
    static let shared = ToDoCache()
    private init() {}

    private var cache: [String: (data: [ToDoItem], timestamp: Date)] = [:]
    private let ttl: TimeInterval = 300 // 5분 캐시

    func get(key: String) -> [ToDoItem]? {
        guard let entry = cache[key] else { return nil }
        if Date().timeIntervalSince(entry.timestamp) < ttl {
            return entry.data
        }
        return nil
    }

    func set(key: String, data: [ToDoItem]) {
        cache[key] = (data, Date())
    }
}
