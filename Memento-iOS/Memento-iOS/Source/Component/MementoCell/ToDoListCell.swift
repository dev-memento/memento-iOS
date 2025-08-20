//
//  ToDoListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/16/25.
//

import SwiftUI
import MDSKit

struct ToDoListCell: View {
    
    var tagColorCode: String
    var title: String
    var toDoType: String
    var endDate: String
    var priority: Priority
    
    var isHighlighted: Bool
    
    @Binding var isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: tagColorCode, width: 3)
            
            CheckBoxView(isChecked: $isCompleted)
            
            VStack(alignment: .leading, spacing: 5) {
                ToDoTitleView(title: title, isChecked: isCompleted)
                
                DueDateView(toDoType: toDoType, endDate: endDate)
            }
            
            Spacer()
            
            PriorityLabelView(priority: priority)
        }
        .frame(height: 68)
        .background(highlightedBackground)
        .opacity(isCompleted ? 0.5 : 1.0)
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
    
    var toDoType: String
    var endDate: String
    
    var body: some View {
        HStack(spacing: 1) {
            //            Image(.img_notion)
            
            Image(.ic_deadline)
                .foregroundColor(Color.gray05)
            
            Text(Date.displayEndDate(endDate))
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
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

struct ToDoListCell_Previews: PreviewProvider {
    @State static var isCompleted = false
    
    static var previews: some View {
        ToDoListCell(
            tagColorCode: "#3867FF",
            title: "건조기 돌리기",
            toDoType: "Personal",
            endDate: "Today",
            priority: .high,
            isHighlighted: false,
            isCompleted: $isCompleted
        )
        .previewLayout(.sizeThatFits)
    }
}
