//
//  TodayView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

import MDSKit
import MCalendar

struct TodayView: View {
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    
    @State private var selectTodo: ToDoListDataModel?
    @State private var selectSchedule: ScheduleListDataModel?
    
    @State private var showTodoAlert = false
    @State private var showScheduleAlert = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    WakeUpHeaderView(wakeUpTime: "8 AM")
                        .padding(.leading, 50)
                        .padding(.bottom, 17)
                    
                    ForEach($viewModel.todayItems, id: \.wrappedValue.id) { item in
                        let isArrow = item.wrappedValue == viewModel.todayItems.first
                        let isHighlighted = isTopPriorityItem(at: item.wrappedValue)
                        
                        TodayListItemView(
                            item: item,
                            isHighlighted: isHighlighted,
                            isArrow: isArrow,
                            backgroundColor: Color.mainNavy,
                            
                            onTodoTap: { todo in
                                selectTodo = todo
                                showTodoAlert = true
                            },
                            onScheduleTap: { schedule in
                                selectSchedule = schedule
                                showScheduleAlert = true
                            }
                        )
                        .padding(.horizontal)
                        .onDrag {
                            viewModel.dragTodayItem = item.wrappedValue
                            return NSItemProvider(object: String(item.id.hashValue) as NSString)
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(item: item, draggedItem: $viewModel.dragTodayItem, onDrop: viewModel.dropActionForToday))
                    }
                    
                    WindDownFooterView(windDownTime: "11 PM")
                        .padding(.leading, 50)
                        .padding(.top, 17)
                }
            }
            .background(Color.grayBlack)
            
            if showTodoAlert, let todo = selectTodo {
                TodoAlertView(
                    todoTitle: todo.toDoTitle,
                    deadline: todo.dueDate,
                    tag: "Work",
                    priority: todo.priorityType,
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
            
            if showScheduleAlert, let schedule = selectSchedule {
                ScheduleAlertView(
                    scheduleTitle: schedule.scheduleTitle,
                    startDate: schedule.startTime,
                    endDate: schedule.endTime,
                    tag: "SOPT",
                    source: "notion",
                    onDelete: {
                        showScheduleAlert = false
                    },
                    onEdit: {
                        showScheduleAlert = false
                    }
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func isTopPriorityItem(at item: TodayItemDataModel) -> Bool {
        guard case .todo(let todo) = item, !todo.isChecked else { return false }
        let uncheckedItems = viewModel.todayItems.filter {
            if case .todo(let t) = $0, !t.isChecked { return true }
            return false
        }
        return uncheckedItems.first == item
    }
}

struct TodayListItemView: View {
    @Binding var item: TodayItemDataModel
    
    var isHighlighted: Bool
    var isArrow: Bool
    var backgroundColor: Color
    
    var onTodoTap: (ToDoListDataModel) -> Void
    var onScheduleTap: (ScheduleListDataModel) -> Void
    
    var body: some View {
        HStack {
            Image(.ic_progress)
                .padding(.leading, -10)
                .padding(.trailing, 5)
                .opacity(isArrow ? 1 : 0)
            
            switch item {
            case .todo(let todo):
                ToDoListCell(
                    isChecked: $item.toDoBinding.isChecked,
                    colorType: todo.colorType,
                    toDoTitle: todo.toDoTitle,
                    dueDate: todo.dueDate,
                    priorityType: todo.priorityType,
                    isHighlighted: isHighlighted,
                    backgroundColor: backgroundColor
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onTodoTap(todo)
                }
                
            case .schedule(let schedule):
                ScheduleListCell(
                    colorType: schedule.colorType,
                    scheduleTitle: schedule.scheduleTitle,
                    startTime: schedule.startTime,
                    endTime: schedule.endTime,
                    isCompleted: schedule.isCompleted
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onScheduleTap(schedule)
                }
            }
        }
    }
}

#Preview{
    TodayView(viewModel: WeeklyCalendarViewModel(
        mCalendarDataSource: MCalendarDataSource(),
        mEventDataSource: MEventDatasource()
    ))
}
