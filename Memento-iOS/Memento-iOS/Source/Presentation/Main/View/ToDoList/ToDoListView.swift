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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ToDoListDateView(date: "Jan 16")
                    .padding(.bottom, 8)
                
                ForEach(viewModel.toDoListItems.indices, id: \.self) { index in
                    ToDoListItemView(
                        item: $viewModel.toDoListItems[index]
                    )
                }
                
                ToDoListDateView(date: "Jan 17")
                    .padding(.bottom, 8)
                
                ForEach(viewModel.toDoListItems.indices, id: \.self) { index in
                    ToDoListItemView(
                        item: $viewModel.toDoListItems[index]
                    )
                }
                
                ToDoListDateView(date: "Jan 18")
                    .padding(.bottom, 8)
                
                ForEach(viewModel.toDoListItems.indices, id: \.self) { index in
                    ToDoListItemView(
                        item: $viewModel.toDoListItems[index]
                    )
                }
                
                ToDoListDateView(date: "Jan 19")
                    .padding(.bottom, 8)
                
                ForEach(viewModel.toDoListItems.indices, id: \.self) { index in
                    ToDoListItemView(
                        item: $viewModel.toDoListItems[index]
                    )
                }
                
                Spacer()
            }
        }
        .background(Color.grayBlack)
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
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                isChecked: $item.isChecked,
                colorType: item.colorType,
                toDoTitle: item.toDoTitle,
                dueDate: item.dueDate,
                priorityType: item.priorityType,
                isHighlighted: false
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

