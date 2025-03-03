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
    @State private var selectedItem: ToDoListDataModel?
    @State private var isChecked = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.mCallendarDataSource.wholeMonthDate, id: \.self) { date in
                        ToDoListDateView(date: "\(makeMonthDate(month: date.month)) \(date.day)")
                            .padding(.bottom, 8)
                            .id(date)
                        if let events = viewModel.toDoListItemDict[date], !events.isEmpty {
                            ForEach(events, id: \.self) { event in
                                ToDoListItemView(
                                    item: event.mapToToDoItem(),
                                    isHighlighted: isTopPriorityItem(at: event, items: events),
                                    backgroundColor: Color.grayBlack,
                                    onTodoTap: { selectedItem in },
                                    onCheckChanged: { isChecked in
                                        if isChecked {
                                            if let index = viewModel.toDoListItemDict[date]?.firstIndex(where: { $0.id == event.id }) {
                                                viewModel.toDoListItemDict[date]?.remove(at: index)
                                                viewModel.toDoListItemDict[date]?.append(event)
                                            }
                                        }
                                        viewModel.updateToDoCompletion(toDoId: event.id, date: date)
                                    }
                                )
                                .onTapGesture {
                                    selectedItem = event
                                    showTodoAlert = true
                                }
                            }
                        } else {
                            Text("No tasks for this date")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
            .background(Color.grayBlack)
            .onAppear {
                viewModel.getToDoListTotalAPI()  // ✅ 캐싱된 데이터 먼저 표시
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.getToDoListTotalAPI(forceRefresh: true)  // ✅ 최신 데이터 갱신
                }
            }
            
            if showTodoAlert, let todo = selectedItem {
                ToDoAlertView(
                    todoId: todo.mapToToDoItem().id,
                    todoTitle: todo.mapToToDoItem().description,
                    deadline: todo.mapToToDoItem().endDate ?? "",
                    tag: todo.mapToToDoItem().tagColor ?? "",
                    priority: todo.priorityType ?? .none,
                    isChecked: $isChecked,
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
                    },
                    todoAPIService: TodoAPIService()
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
            
        }
    }
    
    private func isTopPriorityItem(at item: ToDoListDataModel, items: [ToDoListDataModel]) -> Bool {
        guard !item.isChecked else { return false }
        
        let uncheckedItems = items.filter { !$0.isChecked }
        
        return uncheckedItems.first == item
    }
    
    private func makeMonthDate(month: String) -> String {
        switch month {
        case "1":
            return "Jan"
        case "2":
            return "Feb"
        case "3":
            return "Mar"
        case "4":
            return "Apr"
        case "5":
            return "May"
        case "6":
            return "Jun"
        case "7":
            return "Jul"
        case "8":
            return "Aug"
        case "9":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            return ""
        }
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
    
    var isHighlighted: Bool
    var backgroundColor: Color
    
    var onTodoTap: (ToDoListTotalResponseData) -> Void
    var onCheckChanged: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                toDoList: item,
                toDoListCompleted: ToDoListCompletedResponseData(id: item.id, isCompleted: item.isCompleted),
                isHighlighted: isHighlighted,
                backgroundColor: backgroundColor,
                onCheckChanged: onCheckChanged
            )
        }
        .padding(.bottom, 8)
    }
}

