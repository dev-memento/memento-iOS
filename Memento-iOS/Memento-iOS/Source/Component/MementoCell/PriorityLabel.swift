//
//  PriorityLabel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI
import MDSKit

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
    
    var imageName: MDSImageName {
            switch self {
            case .immediate: return .matrix_immediate
            case .high: return .matrix_high
            case .medium: return .matrix_medium
            case .low: return .matrix_low
            case .none: return .matrix_none
            }
        }
    
    func getPriorityValues() -> (urgency: Double, importance: Double) {
        switch self {
        case .immediate:
            return (0.75, 0.75)
        case .high:
            return (0.25, 0.75)
        case .medium:
            return (0.75, 0.25)
        case .low:
            return (0.25, 0.25)
        case .none:
            return (0.0, 0.0)
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

struct PriorityLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            PriorityLabel(priority: .immediate)
            PriorityLabel(priority: .high)
            PriorityLabel(priority: .medium)
            PriorityLabel(priority: .low)
            PriorityLabel(priority: .none)
        }
        .padding()
        .background(Color.mainNavy)
        .previewLayout(.sizeThatFits)
        
    }
}
