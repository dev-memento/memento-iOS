//
//  ToDoListView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/10/25.
//

import SwiftUI

import MDSKit

struct ToDoListView: View {
    @ObservedObject var viewModel = ToDoListViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.toDoListItems.keys.sorted(), id: \.self) { date in
                    ToDoListItemView(items: $viewModel.toDoListItems[date], date: date)
                }
                .padding(.top, 4)
                
                Spacer()
            }
        }
        .background(Color.grayBlack)
    }
}

struct ToDoListItemView: View {
    @Binding var items: [ToDoListDataModel]?
    let date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .background(Color.gray07)
                .frame(height: 10)
                .padding(.bottom, 2)
            
            HStack {
                Text(date)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray05)
                    .padding(.leading, 22)
                Spacer()
            }
            .frame(height: 20)
            .padding(.bottom, 8)
            
            VStack(spacing: 10) {
                let sortedItems = (items ?? []).sorted { !$0.isChecked && $1.isChecked }
                ForEach(sortedItems.indices, id: \.self) { index in
                    ToDoListCell(
                        isChecked: Binding(
                            get: { sortedItems[index].isChecked },
                            set: { isChecked in
                                if let originalIndex = items?.firstIndex(where: { $0.id == sortedItems[index].id }) {
                                    items?[originalIndex].isChecked = isChecked
                                    items?.sort { !$0.isChecked && $1.isChecked }
                                }
                            }
                        ),
                        colorType: sortedItems[index].colorType,
                        toDoTitle: sortedItems[index].toDoTitle,
                        dueDate: sortedItems[index].dueDate,
                        priorityType: sortedItems[index].priorityType,
                        isHighlighted: index == 0 && !sortedItems[index].isChecked
                    )
                }
            }
            .padding(.bottom, 8)
        }
    }
}

#Preview{
    ToDoListView()
}
