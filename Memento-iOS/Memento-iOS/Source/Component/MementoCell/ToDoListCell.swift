//
//  ToDoListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/16/25.
//

import SwiftUI
import MDSKit

struct ToDoListCell: View {
    var toDoList: ToDoListTotalResponseDataTest
    @Binding var toDoListCompleted: ToDoListCompletedResponseData
    
    var isHighlighted: Bool
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: toDoList.tagColor)
            
            CheckBoxView(isChecked: $toDoListCompleted.isCompleted)
            
            VStack(alignment: .leading) {
                ToDoTitleView(title: toDoList.description, isChecked: toDoListCompleted.isCompleted)
                DueDateView(endDate: toDoList.endDate, toDoType: toDoList.toDoType)
            }
            
            Spacer()
            
            PriorityLabelView(priority: Priority(rawValue: toDoList.priorityType) ?? .none)
        }
        .frame(height: 68)
        .background(highlightedBackground)
        .opacity(toDoListCompleted.isCompleted ? 0.5 : 1.0)
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
            return AnyView(Color.mainNavy)
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
    var endDate: String
    var toDoType: String
    
    var body: some View {
        HStack(spacing: 0) {
            if let toDoImage = toDoIconName(for: toDoType) {
                toDoImage
            }
            
            Image(.ic_deadline)
                .padding(.leading, toDoIconName(for: toDoType) == nil ? 0 : 10)
                .foregroundColor(Color.gray05)
            
            Text(endDate)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
                .padding(.leading, 1)
        }
        
    }
    
    private func toDoIconName(for type: String) -> Image? {
        switch type {
        case "GOOGLE":
            return Image(.img_google)
        case "APPLE":
            return Image(.img_apple)
        default:
            return nil
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
