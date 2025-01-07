//
//  TodoListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct TodoListCell: View {
    
    @State private var isChecked: Bool = false
    
    var colorType: String = "red"
    var todoTitle: String = "UXUI 과제"
    var dueDate: String = "Today"
    var priority: String = "Low"
    var priorityColor: Color = .blue
    
    var body: some View {
        HStack(spacing: 12) {
            
            ColorTagView(colorType: colorType)
            CheckBoxView(isChecked: $isChecked)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(todoTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "flag.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.gray)
                    Text(dueDate)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            PriorityLabel(priority: priority, color: priorityColor)
        }
        .padding()
        .background(Color.black)
    }
}

struct CheckBoxView: View {
    
    @Binding var isChecked: Bool
    
    var body: some View {
        // TODO: - asset 나오면 변경
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, lineWidth: 2)
                .background(isChecked ? Color.gray : Color.clear)
                .frame(width: 16, height: 16)
        }
        .onTapGesture {
            isChecked.toggle()
        }
    }
}

struct PriorityLabel: View {
    
    var priority: String
    var color: Color
    
    var body: some View {
        Text(priority)
            .font(.subheadline)
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color, lineWidth: 1)
            )
    }
}
