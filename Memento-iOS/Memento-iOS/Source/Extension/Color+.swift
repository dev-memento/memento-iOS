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
