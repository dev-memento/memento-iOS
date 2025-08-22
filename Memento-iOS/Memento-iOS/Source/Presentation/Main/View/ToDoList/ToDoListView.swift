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
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @State private var showTodoAlert = false
    @State private var showEditSheet = false
    @State private var selectedItem: ToDoItem?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.mCallendarDataSource.wholeMonthDate, id: \.self) { date in
                        
                        ToDoListDateView(date: "\(Date.makeMonthDate(month: date.month)) \(date.day)")
                            .id(date)
                            .padding(.bottom, 8)
                        
                        if let events = viewModel.toDoListDict[date], !events.isEmpty {
                            ForEach(events, id: \.self) { event in
                                
                                ToDoListItemView(
                                    item: event,
                                    isHighlighted: isTopPriorityItem(at: event, items: events),
                                    isCompleted: Binding(
                                        get: { event.isCompleted },
                                        set: { newValue in
                                            if let index = viewModel.toDoListDict[date]?.firstIndex(where: { $0.id == event.id }) {
                                                viewModel.toDoListDict[date]?[index].isCompleted = newValue
                                                viewModel.updateToDoCompletion(toDoId: event.id)
                                            }
                                        }
                                    )
                                )
                                .onTapGesture {
                                    selectedItem = event
                                    showTodoAlert = true
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .background(Color.grayBlack)
            .onAppear {
                viewModel.getToDoListTotal()
            }
            
            if showTodoAlert, let todo = selectedItem {
                ToDoAlertView(
                    toDoId: todo.id,
                    toDoTitle: todo.description,
                    deadline: todo.endDate,
                    tagName: todo.tagName,
                    tagColorCode: todo.tagColor,
                    priority: todo.priorityType,
                    onDelete: {
                        viewModel.deleteToDo(toDoId: todo.id)
                        showTodoAlert = false
                    },
                    onEdit: {
                        showTodoAlert = false
                        showEditSheet = true
                    },
                    isChecked: Binding(
                        get: { todo.isCompleted },
                        set: { newValue in
                            if let date = viewModel.toDoListDict.first(where: { $0.value.contains(where: { $0.id == todo.id }) })?.key,
                               let index = viewModel.toDoListDict[date]?.firstIndex(where: { $0.id == todo.id }) {
                                viewModel.toDoListDict[date]?[index].isCompleted = newValue
                                viewModel.updateToDoCompletion(toDoId: todo.id)
                                
                                selectedItem?.isCompleted = newValue
                            }
                        }
                    )
                )
                
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EmptyView()
        }
    }
    
    private func isTopPriorityItem(at item: ToDoItem, items: [ToDoItem]) -> Bool {
        guard !item.isCompleted else { return false }
        let uncheckedItems = items.filter { !$0.isCompleted }
        return uncheckedItems.first == item
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
    }
}

struct ToDoListItemView: View {
    
    var item: ToDoItem
    var isHighlighted: Bool
    
    @Binding var isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                tagColorCode: item.tagColor,
                title: item.description,
                toDoType: item.toDoType,
                endDate: item.endDate,
                priority: item.priorityType,
                isHighlighted: isHighlighted,
                isCompleted: $isCompleted
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
