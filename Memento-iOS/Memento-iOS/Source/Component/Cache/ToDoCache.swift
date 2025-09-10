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

    private var cache: [String: [ToDoItem]] = [:]

    func get(key: String) -> [ToDoItem]? {
        return cache[key]
    }

    func set(key: String, data: [ToDoItem]) {
        cache[key] = data
    }
}

