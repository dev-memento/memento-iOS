//
//  ToDoAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct ToDoAlertView: View {
    
    let toDoId: Int
    let toDoTitle: String
    let deadline: String
    let tagName: String
    let tagColorCode: String
    let priority: Priority
    
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    @State private var isLoading: Bool = false
    @Binding var isChecked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(isChecked ? .btn_check_selected_square : .btn_check_unselected_square)
                }
                
                Text(toDoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .strikethrough(isChecked, color: .grayWhite)
                
                Spacer()
            }
            .padding(.top, 22)
            .padding(.leading, 16)
            
            HStack(spacing: 27) {
                Text(StringLiteral.Alert.deadline)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                HStack(spacing: 3) {
                    Image(.ic_deadline)
                        .foregroundColor(.gray05)
                    
                    Text(Date.displayEndDate(deadline))
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)
            
            HStack(spacing: 54) {
                Text(StringLiteral.Common.tag)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                HStack(spacing: 3) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(Color.fromHex(tagColorCode))
                    
                    Text(tagName)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)
            
            HStack(spacing: 36) {
                Text(StringLiteral.Alert.priority)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                PriorityLabel(priority: priority)
                
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 46)
            
            Spacer()
            
            HStack(spacing: 15) {
                DeleteButton(onDelete: onDelete)
                EditButton(onEdit: onEdit)
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 300)
        .background(Color.gray10)
        .cornerRadius(2)
    }
}

struct ToDoAlertView_Previews: PreviewProvider {
    @State static var isChecked = false
    
    static var previews: some View {
        ToDoAlertView(
            toDoId: 1,
            toDoTitle: "건조기 돌리기",
            deadline: "Today",
            tagName: "Personal",
            tagColorCode: "#3867FF",
            priority: .high,
            onDelete: {},
            onEdit: {},
            isChecked: $isChecked
        )
        .previewLayout(.sizeThatFits)
    }
}
