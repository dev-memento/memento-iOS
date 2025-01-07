//
//  Color+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

extension Color {
    
    /// Tag(카테고리)에 따른 Color를 반환하는 정적 메소드
    static func distinguishColorType(_ colorType: String) -> Color {
        switch colorType {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        default: return .gray
        }
    }
}
