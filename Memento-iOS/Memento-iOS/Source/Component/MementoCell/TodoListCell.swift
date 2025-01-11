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
    
    var body: some View {
        HStack {
            ColorTagView(colorType: colorType)
            
            VStack{
                CheckBoxView(isChecked: $isChecked)
                Spacer()
            }
            .padding(.top, 11)
            .padding(.leading, 10)
            
            VStack(alignment: .leading, spacing: 8){
                Text(todoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "circle.square")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "flag.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    Text(dueDate)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray)
                        .padding(.leading, 1)
                }
            }
            .padding(.leading, 10)
            
            Spacer()
            
            VStack{
                PriorityLabel(priority: priorityType)
                Spacer()
            }
            .padding(.top, 10)
            .padding(.trailing, 8)
        }
        .padding(.top, 8)
        .frame(width: 343, height: 68)
        .background(Color.black)
        .onChange(of: isChecked) { _ in
            print("todo box is checked")
        }
    }
}

struct CheckBoxView: View {
    
    @Binding var isChecked: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.gray, lineWidth: 1.5)
            .background(isChecked ? Color.gray : Color.clear)
            .frame(width: 16, height: 16)
        
            .onTapGesture {
                isChecked.toggle()
            }
    }
}
