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
    @State private var selectedItem: ToDoListDataModel?
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.mCallendarDataSource.wholeMonthDate, id: \.self) { date in
                        ToDoListDateView(date: "\(Date.makeMonthDate(month: date.month)) \(date.day)")
                            .padding(.bottom, 8)
                            .id(date)
                        if let events = viewModel.toDoListItemDict[date], !events.isEmpty {
                            ForEach(events, id: \.self) { event in
                                ToDoListItemView(
                                    item: event.mapToToDoItem(),
                                    isChecked: Binding(
                                        get: { event.isChecked },
                                        set: { newValue in
                                            if let index = viewModel.toDoListItemDict[date]?.firstIndex(where: { $0.id == event.id }) {
                                                viewModel.toDoListItemDict[date]?[index].isChecked = newValue
                                                viewModel.updateToDoCompletion(toDoId: event.id)
                                            }
                                        }
                                    ),
                                    isHighlighted: isTopPriorityItem(at: event, items: events),
                                    backgroundColor: Color.grayBlack,
                                    onTodoTap: { selectedItem in }
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
                viewModel.getToDoListTotalAPI()  // ✅ 캐싱된 데이터 먼저 표시
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                    viewModel.getToDoListTotalAPI(forceRefresh: true)  // ✅ 최신 데이터 갱신
                //                }
            }
            
            if showTodoAlert, let todo = selectedItem {
                ToDoAlertView(
                    todoId: todo.mapToToDoItem().id,
                    todoTitle: todo.mapToToDoItem().description,
                    deadline: todo.mapToToDoItem().endDate ?? "",
                    tag: todo.mapToToDoItem().tagColor ?? "",
                    tagName: todo.mapToToDoItem().tagName ?? "",
                    priority: todo.priorityType ?? .none,
                    isChecked: Binding(
                        get: { todo.isChecked },
                        set: { newValue in
                            if let date = viewModel.toDoListItemDict.first(where: { $0.value.contains(where: { $0.id == todo.id }) })?.key,
                               let index = viewModel.toDoListItemDict[date]?.firstIndex(where: { $0.id == todo.id }) {
                                viewModel.toDoListItemDict[date]?[index].isChecked = newValue
                                viewModel.updateToDoCompletion(toDoId: todo.id)
                                
                                selectedItem?.isChecked = newValue
                            }
                        }
                    ),
                    onDelete: {
                        if let date = viewModel.toDoListItemDict.first(where: { $0.value.contains(where: { $0.id == selectedItem?.id }) })?.key,
                           let index = viewModel.toDoListItemDict[date]?.firstIndex(where: { $0.id == selectedItem?.id }) {
                            viewModel.toDoListItemDict[date]?.remove(at: index)
                            
                            if viewModel.toDoListItemDict[date]?.isEmpty == true {
                                viewModel.toDoListItemDict.removeValue(forKey: date)
                            }
                        }
                        showTodoAlert = false
                        viewModel.getToDoListTotalAPI()
                    },
                    onEdit: {
                        showTodoAlert = false
                        showEditSheet = true
                    },
                    todoAPIService: TodoAPIService()
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EmptyView()
        }
    }
    
    private func isTopPriorityItem(at item: ToDoListDataModel, items: [ToDoListDataModel]) -> Bool {
        guard !item.isChecked else { return false }
        
        let uncheckedItems = items.filter { !$0.isChecked }
        
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
    var item: ToDoListTotalResponseDataTest
    @Binding var isChecked: Bool
    
    var isHighlighted: Bool
    var backgroundColor: Color
    
    var onTodoTap: (ToDoListTotalResponseData) -> Void
    
    private var toDoListCompletedBinding: Binding<ToDoListCompletedResponseData> {
        Binding<ToDoListCompletedResponseData>(
            get: {
                ToDoListCompletedResponseData(id: item.id, isCompleted: isChecked)
            },
            set: { newValue in
                isChecked = newValue.isCompleted
            }
        )
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                toDoList: item,
                toDoListCompleted: toDoListCompletedBinding,
                isHighlighted: isHighlighted,
                backgroundColor: backgroundColor
            )
        }
        .padding(.bottom, 8)
    }
}

