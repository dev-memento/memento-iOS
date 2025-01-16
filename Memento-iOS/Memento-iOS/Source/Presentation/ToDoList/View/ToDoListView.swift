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
        VStack(spacing: 0) {
            TodoHeaderView(title: "Navigation", height: 56)
            TodoHeaderView(title: "Weekly Calendar", height: 61)
            
            ForEach(viewModel.items.keys.sorted(), id: \.self) { date in
                            DateSectionView(items: $viewModel.items[date], date: date)
                        }
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
    @Binding var items: [ToDoListDataModel]?
    let date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .background(Color.gray.opacity(0.07))
                .frame(maxHeight: 10)
                .padding(.bottom, 2)
            
            HStack {
                Text(date)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding(.leading, 22)
                Spacer()
            }
            .frame(height: 24)
            
            VStack(spacing: 10) {
                let sortedItems = (items ?? []).sorted { !$0.isChecked && $1.isChecked }
                ForEach(sortedItems.indices, id: \.self) { index in
                    let isHighlighted = index == 0 && !sortedItems[index].isChecked
                    
                    ToDoListCell(
                        isChecked: Binding(
                            get: { sortedItems[index].isChecked },
                            set: { isChecked in
                                if let realIndex = items?.firstIndex(where: { $0.id == sortedItems[index].id }) {
                                    items?[realIndex].isChecked = isChecked
                                    items?.sort { !$0.isChecked && $1.isChecked }
                                }
                            }
                        ),
                        colorType: sortedItems[index].colorType,
                        toDoTitle: sortedItems[index].toDoTitle,
                        dueDate: sortedItems[index].dueDate,
                        priorityType: sortedItems[index].priorityType,
                        isHighlighted: isHighlighted
                    )
                }
            }
            .padding(.bottom, 8)
        }
        .frame(height: items?.isEmpty ?? true ? 36 : nil)
    }
}

#Preview {
    ToDoListView()
}
 
