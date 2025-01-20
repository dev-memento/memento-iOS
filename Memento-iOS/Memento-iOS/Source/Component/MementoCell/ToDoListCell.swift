//
//  ToDoListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/16/25.
//

import SwiftUI
import MDSKit

struct ToDoListCell: View {
    @Binding var isChecked: Bool
    
    var colorType: String
    var toDoTitle: String
    var dueDate: String
    var priorityType: Priority
    
    var isHighlighted: Bool
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: colorType)
            
            CheckBoxView(isChecked: $isChecked)
            
            VStack(alignment: .leading) {
                ToDoTitleView(title: toDoTitle, isChecked: isChecked)
                DueDateView(date: dueDate)
            }
            
            Spacer()
            
            PriorityLabelView(priority: priorityType)
        }
        .frame(height: 68)
        .background(highlightedBackground)
        .opacity(isChecked ? 0.5 : 1.0)
    }
    
    private var highlightedBackground: some View {
        if isHighlighted {
            return AnyView(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.15), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.26, green: 0.27, blue: 0.4), location: 1.00),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        } else {
            return AnyView(backgroundColor)
        }
    }
}

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        VStack {
            Image(isChecked ? .btn_check_selected_square : .btn_check_unselected_square)
                .onTapGesture {
                    isChecked.toggle()
                }
            Spacer()
        }
        .padding(.top, 11)
    }
}

struct ToDoTitleView: View {
    var title: String
    var isChecked: Bool
    
    var body: some View {
        Text(title)
            .applyFont(.body_b_16)
            .foregroundColor(Color.grayWhite)
            .strikethrough(isChecked)
    }
}

struct DueDateView: View {
    var date: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.img_notion)
            Image(.ic_deadline)
                .padding(.leading, 10)
                .foregroundColor(Color.gray05)
            Text(date)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
                .padding(.leading, 1)
        }
    }
}

struct PriorityLabelView: View {
    var priority: Priority
    
    var body: some View {
        VStack {
            PriorityLabel(priority: priority)
            Spacer()
        }
        .padding(.top, 10)
        .padding(.trailing, 8)
    }
}
