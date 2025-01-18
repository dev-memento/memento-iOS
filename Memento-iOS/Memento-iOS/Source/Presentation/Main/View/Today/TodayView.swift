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
        ScrollView {
            VStack(spacing: 8) {
                WakeUpHeaderView(wakeUpTime: "8 AM")
                
                ForEach(viewModel.todayItems.indices, id: \.self) { index in
                    let isArrow = index == 0
                    
                    TodayListItemView(
                        item: $viewModel.todayItems[index],
                        isHighlighted: isTopPriorityItem(at: index),
                        isArrow: isArrow,
                        tappedCell: { item in
                            handleCellTap(item)
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
        .sheet(isPresented: $showTodoAlert) {
            if let todo = selectTodo {
                TodoAlertView(
                    todoTitle: todo.toDoTitle,
                    deadline: todo.dueDate,
                    tag: "Work",
                    priority: todo.priorityType,
                    onDelete: {
                        showTodoAlert = false
                        // customactionsheet의
                    },
                    onEdit: {
                        showTodoAlert = false
                    }
                )
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
    
    private func handleCellTap(_ item: TodayItemDataModel) {
        if case .todo(let todo) = item {
            selectTodo = todo
            showTodoAlert = true
        }
        
    }
}

struct TodayListItemView: View {
    @Binding var item: TodayItemDataModel
    
    var isHighlighted: Bool
    var isArrow: Bool
    var tappedCell: (TodayItemDataModel) -> Void

    @State private var showCustomAlert = false
    @State private var customAlertView: AnyView?

    var body: some View {
        ZStack {
            HStack {
                Group {
                    if isArrow {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                    } else {
                        Spacer()
                            .frame(width: 20)
                            .padding(.trailing, 8)
                    }
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
                        customAlertView = AnyView(
                            TodoAlertView(
                                todoTitle: todo.toDoTitle,
                                deadline: todo.dueDate,
                                tag: "SOPT",
                                priority: todo.priorityType,
                                onDelete: {
                                    print("Delete tapped for \(todo.toDoTitle)")
                                    showCustomAlert = false
                                },
                                onEdit: {
                                    print("Edit tapped for \(todo.toDoTitle)")
                                    showCustomAlert = false
                                }
                            )
                        )
                        showCustomAlert = true
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
                        print("Schedule tapped")
                    }
                }
            }

            if showCustomAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showCustomAlert = false
                    }

                if let customAlertView = customAlertView {
                    customAlertView
                        .frame(width: 343, height: 300)
                        .background(Color.gray10)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                        .transition(.scale)
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
