//
//  TodoListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI
import MDSKit

struct TodoListCell: View {
    @Binding var isChecked: Bool
    
    var todoTitle: String
    var colorType: String
    var dueDate: String
    var priorityType: Priority
    var isHighlighted: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: colorType)
            
            VStack {
                CheckBoxView(isChecked: $isChecked)
                Spacer()
            }
            .padding(.top, 11)
            
            VStack(alignment: .leading) {
                Text(todoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(Color.grayWhite)
                
                HStack(spacing: 0) {
                    Image(.img_notion)
                    Image(.ic_deadline)
                        .padding(.leading, 10)
                    Text(dueDate)
                        .applyFont(.detail_r_12)
                        .foregroundColor(Color.gray05)
                        .padding(.leading, 1)
                }
            }
            
            Spacer()
            
            VStack {
                PriorityLabel(priority: priorityType)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.trailing, 8)
        }
        .frame(height: 68)
        .background(
            isHighlighted
            ? AnyView(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.09, green: 0.1, blue: 0.15), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.26, green: 0.27, blue: 0.4), location: 1.00),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            : AnyView(Color.grayBlack)
        )
        .opacity(isChecked ? 0.5 : 1.0)
        .onChange(of: isChecked) { _ in
            print("todo box is checked")
        }
    }
}

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Image(isChecked ? .btn_check_selected_square : .btn_check_unselected_square)
            .onTapGesture {
                isChecked.toggle()
            }
    }
}
