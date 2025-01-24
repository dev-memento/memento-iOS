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
    @State private var selectSchedule: ScheduleTotalResponseDataTest?
    
    @State private var showTodoAlert = false
    @State private var showScheduleAlert = false
    @State private var isButtonPressed: Bool = false // 버튼 상태를 나타내는 변수
    
    var body: some View {
        ZStack {
            if viewModel.todayItems.isEmpty {
                // Empty 상태일 경우 EmptyView 표시
                EmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        WakeUpHeaderView(wakeUpTime: "8 AM")
                            .padding(.leading, 50)
                            .padding(.bottom, 17)
                        
                        ForEach($viewModel.todayItems, id: \.wrappedValue.id) { item in
                            createTodayListItemView(for: item)
                        }
                        
                        WindDownFooterView(windDownTime: "11 PM")
                            .padding(.leading, 50)
                            .padding(.top, 17)
                    }
                }
                .background(Color.grayBlack)
            }
            
            if showTodoAlert, let todo = selectTodo {
                let todoBinding = Binding<Bool>(
                    get: {
                        if let index = viewModel.todayItems.firstIndex(where: { $0.id == todo.id }),
                           case .todo(let t) = viewModel.todayItems[index] {
                            return t.isChecked
                        }
                        return false
                    },
                    set: { newValue in
                        if let index = viewModel.todayItems.firstIndex(where: { $0.id == todo.id }),
                           case .todo(var t) = viewModel.todayItems[index] {
                            t.isChecked = newValue
                            viewModel.todayItems[index] = .todo(t)
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
            
            if showScheduleAlert, let schedule = selectSchedule {
                ScheduleAlertView(
                    scheduleTitle: schedule.description,
                    startDate: schedule.startDate,
                    endDate: schedule.endDate,
                    tag: "SOPT",
                    source: "Notion",
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
            // 플로팅 버튼
            VStack {
                Spacer() // 위쪽 여백을 채워 아래로 밀기
                HStack {
                    Spacer() // 왼쪽 여백을 채워 오른쪽으로 밀기
                    ZStack {
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(isButtonPressed ? Color.mainGreen : Color.gray09) // 3항 연산자로 색상 변경
                        
                        Button {
                            print("눌림")
                            isButtonPressed.toggle() // 상태 변경
                            let apiService = PrioritizationAPIService()
                            let request = PrioritizationRequest(targetDate: "2025-01-24")
                            
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
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                                .foregroundColor(isButtonPressed ? .white : .black) // 이미지 색상 변경
                        }
                    }
                    .padding(21) // 버튼과 화면 가장자리 간격 설정
                }
            }
        }
    }
    
    private func createTodayListItemView(for item: Binding<TodayItemDataModel>) -> some View {
        let currentItem = item.wrappedValue
        let isArrow = currentItem == viewModel.todayItems.first
        let isHighlighted = isTopPriorityItem(at: currentItem)
        
        return TodayListItemView(
            item: item,
            isHighlighted: isHighlighted,
            isArrow: isArrow,
            backgroundColor: Color.mainNavy,
            onTodoTap: { todo in
                selectTodo = todo
                showTodoAlert = true
            },
            onScheduleTap: { schedule in
                selectSchedule = ScheduleTotalResponseDataTest(
                    id: schedule.id,
                    description: schedule.description,
                    startDate: schedule.startDate,
                    endDate: schedule.endDate,
                    timeDuration: schedule.timeDuration,
                    isAllDay: schedule.isAllDay,
                    scheduleType: schedule.scheduleType,
                    order: schedule.order,
                    tagName: schedule.tagName,
                    tagColorCode: schedule.tagColorCode)
            }
        )
        .padding(.horizontal)
        .onDrag {
            viewModel.dragTodayItem = currentItem
            return NSItemProvider(object: String(currentItem.id.hashValue) as NSString)
        }
        .onDrop(of: [.text], delegate: DropViewDelegate(item: item, draggedItem: $viewModel.dragTodayItem, onDrop: viewModel.dropActionForToday))
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
    var onScheduleTap: (ScheduleTotalResponseDataTest) -> Void
    
    var body: some View {
        HStack {
            Image(.ic_progress)
                .padding(.leading, -10)
                .padding(.trailing, 5)
                .opacity(isArrow ? 1 : 0)
            
            // ScheduleListCell 추가
            if case .schedule(let schedule) = item {
                ScheduleListCell(schedule: schedule)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onScheduleTap(schedule)
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .background(backgroundColor)
    }
}

//#Preview{
//    TodayView(viewModel: WeeklyCalendarViewModel(
//        mCalendarDataSource: MCalendarDataSource(),
//        mEventDataSource: MEventDatasource()
//    ))
//}
