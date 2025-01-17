//
//  PriorityLabel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI
import MDSKit

/// Todo 관리에 필요한 중요도 표시 라벨
enum Priority: String {
    case immediate, high, medium, low, none
    
    var strokeColor: Color {
        switch self {
        case .immediate: return Color.labelImmediate
        case .high: return Color.labelHigh
        case .medium: return Color.labelMedium
        case .low: return Color.labelLow
        case .none: return Color.gray07
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .immediate: return Color.labelImmediate15
        case .high: return Color.labelHigh15
        case .medium: return Color.labelMedium15
        case .low: return Color.labelLow15
        case .none: return Color.mainNavy
        }
    }
    
    var title: String {
        switch self {
        case .immediate: return StringLiteral.Priority.immediate
        case .high: return StringLiteral.Priority.high
        case .medium: return StringLiteral.Priority.medium
        case .low: return StringLiteral.Priority.low
        case .none: return StringLiteral.Priority.none
        }
    }
}

struct PriorityLabel: View {
    
    var priority: Priority
    
    var body: some View {
        Text(priority.title)
            .applyFont(.detail_b_12)
            .foregroundColor(Color.gray04)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(priority.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .inset(by: 0.15)
                    .stroke(priority.strokeColor, lineWidth: 0.3)
            )
    }
}
