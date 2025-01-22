//
//  Color+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

extension Color {
    static func distinguishColorType(_ colorType: String) -> Color {
        switch colorType {
        case "mementoRed": return Color.mementoRed
        case "mementoBlue": return Color.mementoBlue
        case "mementoCyan": return Color.mementoCyan
        case "mementoMint": return Color.mementoMint
        case "mementoPink": return Color.mementoPink
        case "mementoOrange": return Color.mementoOrange
        case "mementoPurple": return Color.mementoPurple
        case "mementoYellow": return Color.mementoYellow
        case "mementoLightGreen": return Color.mementoLightGreen
        default: return Color.gray05
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }

    /// 헥스 코드 문자열로부터 색상 반환 (유효하지 않으면 기본값 반환)
    static func fromHex(_ hex: String) -> Color {
       return  Color(hex: hex)

    }

}
