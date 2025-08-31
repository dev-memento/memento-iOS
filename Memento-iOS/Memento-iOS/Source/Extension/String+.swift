//
//  String+.swift
//  Memento-iOS
//
//  Created by RAFA on 4/10/25.
//

import Foundation

extension String {
    
    func base64Padded() -> String {
        let padding = 4 - count % 4
        return self + String(repeating: "=", count: padding % 4)
    }
    
    /// 서버에서 내려준 "HH:mm" 형식의 문자열을 Date로 변환
    /// SettingView의 wakeUpTime / sleepTime 초기화 시 사용
    func toHourMinuteDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
}
