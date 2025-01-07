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
            
            PriorityLabel(priority: .high)
                .padding(.trailing, 12)
        }
        .frame(height: 70)
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
