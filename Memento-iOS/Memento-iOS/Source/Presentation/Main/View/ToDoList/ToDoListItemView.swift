//
//  ToDoListItemView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/24/25.
//

import SwiftUI

struct ToDoListItemView: View {
    let item: ToDoListTotalResponseDataTest
    
    var isHighlighted: Bool
    var backgroundColor: Color
    
    var onTodoTap: (ToDoListTotalResponseData) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                toDoList: item,
                isHighlighted: item.isCompleted,
                backgroundColor: backgroundColor
            )
        }
        .padding(.bottom, 8)
    }
}

