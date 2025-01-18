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

                    ForEach(viewModel.todayItems.indices, id: \ .self) { index in
                        let isArrow = index == 0

                        TodayListItemView(
                            item: $viewModel.todayItems[index],
                            isHighlighted: isTopPriorityItem(at: index),
                            isArrow: isArrow,
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
                            viewModel.dragItem = viewModel.todayItems[index]
                            return NSItemProvider()
                        }
                        .onDrop(
                            of: [.text],
                            delegate: DropViewDelegate(
                                item: $viewModel.todayItems[index],
                                items: $viewModel.todayItems,
                                draggedItem: $viewModel.dragItem,
                                onDrop: viewModel.dropAction
                            )
                        )
                    }

                    WindDownFooterView(windDownTime: "11 PM")
                }
                .padding(.vertical)
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
    
    private func isTopPriorityItem(at index: Int) -> Bool {
        guard case .todo(let todo) = viewModel.todayItems[index], !todo.isChecked else { return false }
        return viewModel.todayItems.prefix(index + 1).filter {
            if case .todo(let t) = $0, !t.isChecked { return true }
            return false
        }.count == 1
    }
}

struct TodayListItemView: View {
    @Binding var item: TodayItemDataModel

    var isHighlighted: Bool
    var isArrow: Bool
    var onTodoTap: (ToDoListDataModel) -> Void
    var onScheduleTap: (ScheduleListDataModel) -> Void

    var body: some View {
        HStack {
            if isArrow {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .padding(.trailing, 8)
            } else {
                Spacer()
                    .frame(width: 20)
                    .padding(.trailing, 8)
            }

            switch item {
            case .todo(let todo):
                ToDoListCell(
                    isChecked: $item.toDoBinding.isChecked,
                    colorType: todo.colorType,
                    toDoTitle: todo.toDoTitle,
                    dueDate: todo.dueDate,
                    priorityType: todo.priorityType,
                    isHighlighted: isHighlighted
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onTodoTap(todo)
                }

            case .schedule(let schedule):
                ScheduleListCell(
                    colorType: schedule.colorType,
                    scheduleTitle: schedule.scheduleTitle,
                    time: schedule.startTime,
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

struct DropViewDelegate: DropDelegate {
    @Binding var item: TodayItemDataModel
    @Binding var items: [TodayItemDataModel]
    @Binding var draggedItem: TodayItemDataModel?
    
    let onDrop: (TodayItemDataModel?, TodayItemDataModel) -> Void
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            draggedItem = nil
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem else { return }
        onDrop(draggedItem, item)
    }
}
