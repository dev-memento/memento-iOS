//
//  PriorityLabel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

/// Todo 관리에 필요한 중요도 표시 라벨
enum Priority: String {
    case immediate, high, medium, low, none
    
    var color: Color {
        switch self {
        case .immediate: return .red
        case .high: return .yellow
        case .medium: return .green
        case .low: return .blue
        case .none: return .gray
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
            .font(.subheadline)
            .foregroundColor(priority.color)
            .padding(.horizontal, 3)
            .padding(.vertical, 1)
            .background(priority.color.opacity(0.1))
            .overlay(
                Rectangle()
                    .stroke(priority.color, lineWidth: 0.4)
            )
    }
}

