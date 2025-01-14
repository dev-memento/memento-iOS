//
//  ToDoListView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/10/25.
//

import SwiftUI
import MDSKit

struct ToDoListView: View {
    @State private var todoItems: [String: [TodoItem]] = [
        "Jan 3": [
            TodoItem(id: UUID(), title: "밥 먹기", colorType: "blue", dueDate: "Today", priority: .immediate, isChecked: false),
            TodoItem(id: UUID(), title: "Swift 공부", colorType: "green", dueDate: "Today", priority: .high, isChecked: false),
            TodoItem(id: UUID(), title: "디자인 검토", colorType: "red", dueDate: "Today", priority: .low, isChecked: false),
            TodoItem(id: UUID(), title: "코드 리뷰", colorType: "orange", dueDate: "Today", priority: .high, isChecked: false)
        ],
        "Jan 4": [],
        "Jan 5": [
            TodoItem(id: UUID(), title: "청소하기", colorType: "orange", dueDate: "Today", priority: .low, isChecked: false)
        ]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            TodoHeaderView(title: "Navigation", height: 56)
            TodoHeaderView(title: "Weekly Calendar", height: 61)
            
            ForEach(todoItems.keys.sorted(), id: \.self) { date in
                DateSectionView(todoItems: $todoItems, date: date)
            }
            .padding(.top, 4)
            .padding(.top, 4)
            
            Spacer()
        }
        .background(Color.black)
    }
}

struct TodoHeaderView: View {
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
    @Binding var todoItems: [String: [TodoItem]]
    let date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .background(Color.gray07)
                .frame(maxHeight: 10)
                .padding(.bottom, 2)
            
            HStack {
                Text(date)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray05)
                    .padding(.leading, 22)
                Spacer()
            }
            .frame(height: 24)
            
            VStack(spacing: 10) {
                let sortedItems = (todoItems[date] ?? []).sorted { !$0.isChecked && $1.isChecked }
                
                ForEach(sortedItems, id: \.id) { item in
                    TodoListCell(
                        isChecked: Binding(
                            get: { item.isChecked },
                            set: { isChecked in
                                if let index = todoItems[date]?.firstIndex(where: { $0.id == item.id }) {
                                    todoItems[date]?[index].isChecked = isChecked
                                    todoItems[date]?.sort { $0.isChecked && !$1.isChecked }
                                }
                            }
                        ),
                        todoTitle: item.title,
                        colorType: item.colorType,
                        dueDate: item.dueDate,
                        priorityType: item.priority
                    )
                }
            }
            .padding(.bottom, 8)
        }
        .frame(height: todoItems[date]?.isEmpty ?? true ? 36 : nil)
    }
}

struct TodoItem: Identifiable {
    let id: UUID
    let title: String
    let colorType: String
    let dueDate: String
    let priority: Priority
    var isChecked: Bool
}

#Preview {
    ToDoListView()
}
