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
    
    @Binding var isToDoAlertPresented: Bool
    @Binding var isScheduleAlertPresented: Bool
    @Binding var selectedToDo: ToDoItem?
    @Binding var selectedSchedule: ScheduleItem?
    
    var body: some View {
        ZStack {
            if viewModel.todayItems.isEmpty {
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        WakeUpHeaderView(wakeUpTime: viewModel.wakeUpTime)
                            .padding(.leading, 50)
                            .padding(.bottom, 15)
                        
                        ForEach(viewModel.todayItems, id: \.id) { item in
                            TodayListItemView(
                                item: item,
                                isArrow: item == viewModel.todayItems.first,
                                isHighlighted: viewModel.isTopPriorityItem(item: item),
                                isCompleted: viewModel.bindingForToDoCompletion(item.id)
                            )
                            .padding(.bottom, 10)
                            .onTapGesture {
                                switch item {
                                case .todo(let todo):
                                    selectedToDo = todo
                                    isToDoAlertPresented = true
                                case .schedule(let schedule):
                                    selectedSchedule = schedule
                                    isScheduleAlertPresented = true
                                }
                            }
                            //        .onDrag {
                            //            viewModel.dragTodayItem = currentItem
                            //            return NSItemProvider(object: String(currentItem.id.hashValue) as NSString)
                            //        }
                            //        .onDrop(of: [.text], delegate: DropViewDelegate(item: item, draggedItem: $viewModel.dragTodayItem, onDrop: viewModel.dropActionForToday))
                        }
                        
                        WindDownFooterView(windDownTime: viewModel.windDownTime)
                            .padding(.leading, 50)
                            .padding(.top, 17)
                    }
                }
                .background(Color.grayBlack)
                .onAppear {
                    viewModel.getUserUptime()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("updateUptime"))) { _ in
                    viewModel.getUserUptime()
                }
            }
        }
    }
}

struct TodayListItemView: View {
    
    var item: TodayItem
    
    var isArrow: Bool
    var isHighlighted: Bool
    
    @Binding var isCompleted: Bool
    
    var body: some View {
        HStack {
            Image(.ic_progress)
                .padding(.leading, -10)
                .padding(.trailing, 5)
                .opacity(isArrow ? 1 : 0)
            
            switch item {
            case .todo(let todo):
                ToDoListCell(
                    tagColorCode: todo.tagColor,
                    title: todo.description,
                    toDoType: todo.toDoType,
                    endDate: todo.endDate,
                    priority: todo.priorityType,
                    isHighlighted: isHighlighted,
                    isCompleted: $isCompleted
                )
                
            case .schedule(let schedule):
                ScheduleListCell(
                    tagColorCode: schedule.tagColorCode,
                    title: schedule.description,
                    scheduleType: schedule.scheduleType,
                    endDate: schedule.endDate,
                    timeDuration: schedule.timeDuration
                )
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
