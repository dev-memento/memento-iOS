//
//  TodoAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct TodoAlertView: View {
    
    let todoTitle: String
    let deadline: String
    let tag: String
    let priority: Priority

    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.btn_check_unselected_square)
                Text(todoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                Spacer()
            }
            .padding(.top, 22)
            .padding(.leading, 16)

            HStack {
                Text("Deadline")
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 27)
                
                HStack(spacing: 3) {
                    Image(.ic_deadline)
                    Text(deadline)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)

    
            HStack {
                Text("Tag")
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 54)
                
                HStack(spacing: 3) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    Text(tag)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.grayWhite)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)

            
            HStack {
                Text("Priority")
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 36)
             
                PriorityLabel(priority: priority)
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 46)

            Spacer()

            
            HStack {
                Button(action: {
                    onDelete()
                }) {
                    HStack {
                        Image(.ic_delete)
                        Text("Delete")
                    }
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.labelImmediate15)
                    .cornerRadius(2)
                }

                Button(action: {
                    onEdit()
                }) {
                    HStack {
                        Image(.ic_edit)
                        Text("Edit")
                    }
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray09)
                    .cornerRadius(2)
                }
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 300)
        .padding()
        .background(Color.gray10)
        .cornerRadius(2)
    }
}

struct ContentView: View {
    var body: some View {
        TodoAlertView(
            todoTitle: "UXUI 과제",
            deadline: "Today",
            tag: "SOPT",
            priority: .high,
            onDelete: {
                print("Delete action triggered")
            },
            onEdit: {
                print("Edit action triggered")
            }
        )
        .preferredColorScheme(.dark)
    }
}

struct TodoAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
