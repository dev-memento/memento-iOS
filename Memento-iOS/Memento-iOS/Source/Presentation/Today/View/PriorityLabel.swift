//
//  PriorityLabel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

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
        case .immediate: return "Immediate"
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .none: return "None"
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

