//
//  ToDoAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct ToDoAlertView: View {
    
    let todoTitle: String
    let deadline: String
    let tag: String
    let priority: Priority

    var onDelete: () -> Void
    var onEdit: () -> Void
    
    @State private var isCompleted: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    isCompleted.toggle()
                }) {
                    Image(isCompleted ? .btn_check_selected_square : .btn_check_unselected_square)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(todoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .strikethrough(isCompleted, color: .grayWhite)
                Spacer()
            }
            .padding(.top, 22)
            .padding(.leading, 16)

            HStack {
                Text(StringLiteral.Alert.deadline)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 27)
                
                HStack(spacing: 3) {
                    Image(.ic_deadline)
                        .foregroundColor(.gray05)
                    Text(deadline)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)

    
            HStack {
                Text(StringLiteral.Alert.tag)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 54)
                
                HStack(spacing: 3) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(.mementoBlue)
                    Text(tag)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)

            
            HStack {
                Text(StringLiteral.Alert.priority)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 36)
             
                PriorityLabel(priority: priority)
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 46)

            Spacer()

            HStack(spacing: 15) {
                Button(action: {
                    onDelete()
                }) {
                    VStack {
                        Image(.ic_delete)
                            .foregroundColor(.mementoRed)
                        Text(StringLiteral.Alert.delete)
                    }
                    .applyFont(.body_r_16)
                    .foregroundColor(.mementoRed)
                    .padding()
                    .frame(width: 140, height: 74)
                    .background(Color.labelImmediate15)
                    .cornerRadius(2)
                }

                Button(action: {
                    onEdit()
                }) {
                    VStack {
                        Image(.ic_edit)
                        Text(StringLiteral.Alert.edit)
                    }
                    .applyFont(.body_r_16)
                    .foregroundColor(.gray05)
                    .padding()
                    .frame(width: 140, height: 74)
                    .background(Color.gray09)
                    .cornerRadius(2)
                }
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 300)
        .background(Color.gray10)
        .cornerRadius(2)
    }
}


#Preview {
    ToDoAlertView(todoTitle: "UXUI 과제", deadline: "Today", tag: "SOPT", priority: .high,
                  onDelete: {
        print("Delete button tapped")
    },
                  onEdit: {
        print("Edit button tapped")
    }
    )
}
