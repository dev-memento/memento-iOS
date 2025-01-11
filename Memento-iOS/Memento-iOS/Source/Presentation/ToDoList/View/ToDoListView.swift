//
//  ToDoListView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/10/25.
//

import SwiftUI

struct ToDoListView: View {
    @State private var isChecked = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Navigation", height: 56)
            HeaderView(title: "Weekly Calendar", height: 61)
            
            VStack(spacing: 8) {
                DateSectionView(date: "Jan 3", content: [
                    TodoListCell(isChecked: $isChecked, colorType: "blue", todoTitle: "밥 먹기", dueDate: "Today"),
                    TodoListCell(isChecked: $isChecked, colorType: "green", todoTitle: "Swift 공부", dueDate: "Today"),
                    TodoListCell(isChecked: $isChecked, colorType: "red", todoTitle: "디자인 검토", dueDate: "Today")
                ])
                DateSectionView(date: "Jan 4", content: [])
                DateSectionView(date: "Jan 5", content: [
                    TodoListCell(isChecked: $isChecked, colorType: "orange", todoTitle: "코드 리뷰", dueDate: "Today")
                ])
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .background(Color.black)
    }
}

struct HeaderView: View {
    let title: String
    var height: CGFloat
    
    var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(.clear)
            .overlay(
                Text(title)
                    .foregroundColor(.white)
            )
    }
}

struct DateSectionView: View {
    let date: String
    let content: [TodoListCell]
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .background(Color(red: 0.66, green: 0.68, blue: 0.73))
                .frame(maxHeight: 10)
                .padding(.bottom, 2)
            
            HStack {
                Text(date)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.66, green: 0.68, blue: 0.73))
                    .padding(.leading, 22)
                Spacer()
            }
            .frame(height: 24)
            
            VStack(spacing: 10) {
                ForEach(0..<content.count, id: \.self) { index in
                    content[index]
                }
            }
            .padding(.bottom, 8)
        }
        .frame(height: content.isEmpty ? 36 : nil)
    }
}
