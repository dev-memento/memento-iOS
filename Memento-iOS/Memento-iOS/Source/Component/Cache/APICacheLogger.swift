//
//  APICacheLogger.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 9/3/25.
//

import Foundation

final class APICacheLogger {
    static let shared = APICacheLogger()
    private init() {}

    private var serverTimes: [String: [Double]] = [:]
    private var cacheTimes: [String: [Double]] = [:]

    func logServerCall(start: Date, apiName: String) {
        let elapsed = Date().timeIntervalSince(start) * 1000
        serverTimes[apiName, default: []].append(elapsed)
//        print("📌 [SERVER] \(apiName) — \(String(format: "%.2f", elapsed))ms")
    }

    func logCacheCall(start: Date, apiName: String) {
        let elapsed = Date().timeIntervalSince(start) * 1000
        cacheTimes[apiName, default: []].append(elapsed)
//        print("📌 [CACHE] \(apiName) — \(String(format: "%.2f", elapsed))ms")
    }

    /// 캐시 vs 서버 개선율 + 일반 통계 모두 출력
    func report(apiName: String) {
        if let server = serverTimes[apiName], !server.isEmpty {
            let avg = server.reduce(0,+) / Double(server.count)
            let minVal = server.min() ?? 0
            let maxVal = server.max() ?? 0
//            print("📊 \(apiName) 서버 통계 → 호출: \(server.count), 평균: \(String(format: "%.2f", avg))ms, 최소: \(String(format: "%.2f", minVal))ms, 최대: \(String(format: "%.2f", maxVal))ms")
        }

        if let cache = cacheTimes[apiName], !cache.isEmpty {
            let avg = cache.reduce(0,+) / Double(cache.count)
            let minVal = cache.min() ?? 0
            let maxVal = cache.max() ?? 0
//            print("📊 \(apiName) 캐시 통계 → 호출: \(cache.count), 평균: \(String(format: "%.2f", avg))ms, 최소: \(String(format: "%.2f", minVal))ms, 최대: \(String(format: "%.2f", maxVal))ms")
        }

        if let server = serverTimes[apiName], let cache = cacheTimes[apiName], !server.isEmpty, !cache.isEmpty {
            let serverAvg = server.reduce(0,+) / Double(server.count)
            let cacheAvg = cache.reduce(0,+) / Double(cache.count)
            let improvement = (serverAvg - cacheAvg) / serverAvg * 100
            let absolute = serverAvg - cacheAvg
//            print("🚀 \(apiName) 개선율: \(String(format: "%.2f", improvement))% (↓\(String(format: "%.2f", absolute))ms)")
        }
    }

    func reset() {
        serverTimes.removeAll()
        cacheTimes.removeAll()
    }
}
