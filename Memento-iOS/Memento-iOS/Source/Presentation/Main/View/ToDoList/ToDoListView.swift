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
    
    @State private var selectTodo: ToDoListDataModel?
    @State private var showTodoAlert = false
    
    let dates = ["Jan 18", "Jan 19", "Jan 20", "Jan 21", "Jan 22"]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(dates, id: \.self) { date in
                        ToDoListDateView(date: date)
                            .padding(.bottom, 8)
                        
                        let sortedItems = viewModel.toDoListItems
                            .sorted { !$0.isChecked && $1.isChecked }
                        
                        ForEach($viewModel.toDoListItems, id: \.id) { item in
                            let originalIndex = viewModel.toDoListItems.firstIndex(where: { $0 == item.wrappedValue})!
                            let isHighlighted = isTopPriorityItem(at: item.wrappedValue, items: sortedItems)
                            
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
                                isHighlighted: isHighlighted,
                                backgroundColor: Color.grayBlack
                            )
                            .onTapGesture {
                                selectTodo = item.wrappedValue
                                showTodoAlert = true
                            }
                            .onDrag {
                                viewModel.dragTodoItem = item.wrappedValue
                                return NSItemProvider(object: String(item.id.hashValue) as NSString)
                            }
                            .onDrop(of: [.text], delegate: DropViewDelegate(item: item, draggedItem: $viewModel.dragTodoItem, onDrop: viewModel.dropActionForToDoList))
                        }
                    }
                    Spacer()
                }
            }
            .background(Color.grayBlack)
            
            if showTodoAlert, let todo = selectTodo {
                let todoBinding = Binding<Bool>(
                    get: {
                        if let index = viewModel.toDoListItems.firstIndex(where: { $0.id == todo.id }) {
                            return viewModel.toDoListItems[index].isChecked
                        }
                        return false
                    },
                    set: { newValue in
                        if let index = viewModel.toDoListItems.firstIndex(where: { $0.id == todo.id }) {
                            viewModel.toDoListItems[index].isChecked = newValue
                            if newValue {
                                let item = viewModel.toDoListItems.remove(at: index)
                                viewModel.toDoListItems.append(item)
                            }
                            selectTodo = viewModel.toDoListItems.first(where: { $0.id == todo.id })
                        }
                    }
                )
                
                ToDoAlertView(
                    todoTitle: todo.toDoTitle,
                    deadline: todo.dueDate,
                    tag: "Work",
                    priority: todo.priorityType,
                    isChecked: todoBinding,
                    onDelete: {
                        showTodoAlert = false
                    },
                    onEdit: {
                        showTodoAlert = false
                    }
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func isTopPriorityItem(at item: ToDoListDataModel, items: [ToDoListDataModel]) -> Bool {
        guard !item.isChecked else { return false }
        guard let currentIndex = items.firstIndex(where: { $0 == item }) else {
            return false
        }
        let uncheckedCount = items.prefix(upTo: currentIndex).filter { !$0.isChecked }.count
        return uncheckedCount == 0
    }
}

struct ToDoListDateView: View {
    var date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
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
    var backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                isChecked: $item.isChecked,
                colorType: item.colorType,
                toDoTitle: item.toDoTitle,
                dueDate: item.dueDate,
                priorityType: item.priorityType,
                isHighlighted: isHighlighted,
                backgroundColor: backgroundColor
            )
        }
        .padding(.bottom, 8)
    }
}

//#Preview {
//    ToDoListView(viewModel: WeeklyCalendarViewModel(
//        mCalendarDataSource: MCalendarDataSource(),
//        mEventDataSource: MEventDatasource()
//    ))
//}
