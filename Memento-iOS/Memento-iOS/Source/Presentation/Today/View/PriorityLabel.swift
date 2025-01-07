//
//  PriorityLabel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

enum Priority: String {
    case immediate = "Immediate"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    case none = "None"
    
    var color: Color {
        switch self {
        case .immediate: return .red
        case .high: return .yellow
        case .medium: return .green
        case .low: return .blue
        case .none: return .gray
        }
    }
}

struct PriorityLabel: View {
    var priority: Priority
    
    var body: some View {
        Text(priority.rawValue)
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

