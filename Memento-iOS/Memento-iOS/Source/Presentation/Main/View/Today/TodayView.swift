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
    
    @ObservedObject var viewModel: TodayWeeklyCalendarViewModel
    
    @State private var selectTodo: ToDoItem?
    @State private var selectSchedule: ScheduleWithOrderInfos?
    
    @State private var showTodoAlert = false
    @State private var showScheduleAlert = false
    @State private var aiPlottingButtonpPressed: Bool = false
    
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
                        
                        ForEach($viewModel.todayItems, id: \.wrappedValue.id) { item in
                            let todayItem = item.wrappedValue
                            
                            TodayListItemView(
                                item: todayItem,
                                isArrow: todayItem == viewModel.todayItems.first,
                                isHighlighted: viewModel.isTopPriorityItem(item: todayItem),
                                isCompleted: viewModel.bindingForToDoCompletion(todayItem.id),
                                onToDoTap: { _ in
                                    showTodoAlert = true
                                },
                                onScheduleTap: { _ in
                                    showScheduleAlert = true
                                }
                            )
                            .padding(.bottom, 10)
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
            }
            
            if showTodoAlert,
               let todo = selectTodo {
                let todoBinding = Binding<Bool>(
                    get: {
                        if let index = viewModel.todayItems.firstIndex(where: { $0.id == todo.id }),
                           case .todo(let t) = viewModel.todayItems[index] {
                            return t.isCompleted
                        }
                        return false
                    },
                    set: { newValue in
                        if let index = viewModel.todayItems.firstIndex(where: { $0.id == todo.id }),
                           case .todo(var t) = viewModel.todayItems[index] {
                            t.isCompleted = newValue
                            viewModel.todayItems[index] = .todo(t)
                        }
                    }
                )
                
                ToDoAlertView(
                    toDoId: todo.id,
                    toDoTitle: todo.description,
                    deadline: todo.endDate,
                    tagName: todo.tagName,
                    tagColorCode: todo.tagColor,
                    priority: todo.priorityType,
                    onDelete: {
                        showTodoAlert = false
                    },
                    onEdit: {
                        showTodoAlert = false
                    },
                    isChecked: todoBinding
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
            
            if showScheduleAlert, let schedule = selectSchedule {
                ScheduleAlertView(
                    scheduleId: schedule.id,
                    scheduleTitle: schedule.description,
                    startDate: schedule.startDate,
                    endDate: schedule.endDate,
                    tagName: schedule.tagName,
                    tagColorCode: schedule.tagColorCode,
                    scheduleType: "Notion",
                    onDelete: {
                        viewModel.deleteSchedule(scheduleId: schedule.id)
                        showScheduleAlert = false
                    },
                    onEdit: {
                        showScheduleAlert = false
                    }
                )
                .background(Color.black.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
            
            // 플로팅 버튼
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(aiPlottingButtonpPressed ? Color.mainGreen : Color.gray09)
                        
                        Button {
                            aiPlottingButtonpPressed.toggle()
                            let apiService = PrioritizationAPIService()
                            let request = PrioritizationRequest(targetDate: "2025-08-18")
                            
                            apiService.fetchPrioritization(request: request) { result in
                                switch result {
                                case .success(let response):
                                    print("fetchPrioritization 성공")
                                default:
                                    print("fetchPrioritization 실패:")
                                }
                            }
                        } label: {
                            Image(.ic_prio)
                                .renderingMode(.template)
                                .foregroundColor(aiPlottingButtonpPressed ? .grayBlack : .grayWhite)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .overlay {
            if aiPlottingButtonpPressed {
                NeonAnimationView(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        aiPlottingButtonpPressed = false
                    }
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
    
    var onToDoTap: (ToDoItem) -> Void
    var onScheduleTap: (ScheduleItem) -> Void
    
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
                .onTapGesture {
                    onToDoTap(todo)
                }
                
            case .schedule(let schedule):
                ScheduleListCell(
                    tagColorCode: schedule.tagColorCode,
                    title: schedule.description,
                    scheduleType: schedule.scheduleType,
                    endDate: schedule.endDate,
                    timeDuration: schedule.timeDuration
                )
                .onTapGesture {
                    onScheduleTap(schedule)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
