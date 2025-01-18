//
//  ToDoListView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/10/25.
//

import SwiftUI

import MDSKit
import MCalendar

struct ToDoListView: View {
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    
    let dates = ["Jan 16", "Jan 17", "Jan 18", "Jan 19"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(dates, id: \.self) { date in
                    ToDoListDateView(date: date)
                        .padding(.bottom, 8)
                    
                    let sortedItems = viewModel.toDoListItems
                        .sorted { !$0.isChecked && $1.isChecked }
                    
                    ForEach(sortedItems.indices, id: \.self) { index in
                        let originalIndex = viewModel.toDoListItems.firstIndex(where: { $0.id == sortedItems[index].id })!
                        let isHighlighted = isTopPriorityItem(at: index, items: sortedItems)
                        
                        ToDoListItemView(
                            item: Binding(
                                get: { viewModel.toDoListItems[originalIndex] },
                                set: { newValue in
                                    viewModel.toDoListItems[originalIndex] = newValue
                                    if newValue.isChecked {
                                        viewModel.toDoListItems.append(viewModel.toDoListItems.remove(at: originalIndex))
                                    }
                                }
                            ),
                            isHighlighted: isHighlighted
                        )
                    }
                }
                
                Spacer()
            }
        }
        .background(Color.grayBlack)
    }
    
    private func isTopPriorityItem(at index: Int, items: [ToDoListDataModel]) -> Bool {
        guard !items[index].isChecked else { return false }
        return items.prefix(index + 1).filter { !$0.isChecked }.count == 1
    }
}

struct ToDoListDateView: View {
    var date: String
    
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
        }
        .id(date)
    }
}

struct ToDoListItemView: View {
    @Binding var item: ToDoListDataModel
    var isHighlighted: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                isChecked: $item.isChecked,
                colorType: item.colorType,
                toDoTitle: item.toDoTitle,
                dueDate: item.dueDate,
                priorityType: item.priorityType,
                isHighlighted: isHighlighted
            )
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ToDoListView(viewModel: WeeklyCalendarViewModel(
        mCalendarDataSource: MCalendarDataSource(),
        mEventDataSource: MEventDatasource()
    ))
}
