//
//  Date+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import Foundation

extension Date {
    
    /// 현재 날짜와 시간을 특정 형식의 문자열로 반환하는 메소드
    /// 사용법: Date().makeCurrentDate()
    func makeCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
}
