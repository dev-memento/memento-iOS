//
//  Color+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

extension Color {
    static func fromHex(_ hex: String) -> Color {
        return  Color(hex: hex)
    }
    
    func toHex() -> String {
            let uiColor = UIColor(self)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0

            if !uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) {
                return "#000000"
            }
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)
            return String(format:"#%06X", rgb)
        }
}
