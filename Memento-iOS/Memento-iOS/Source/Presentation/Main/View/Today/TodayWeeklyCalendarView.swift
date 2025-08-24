//
//  TodayWeeklyCalendarView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import SwiftUI
import MDSKit
import MCalendar

struct TodayWeeklyCalendarView: View {
    
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    @StateObject private var settingViewModel = SettingViewModel()
    
    @State private var isToDoAlertPresented: Bool = false
    @State private var isScheduleAlertPresented: Bool = false
    @State private var isSettingViewPresented = false
    
    @State private var selectedToDo: ToDoItem? = nil
    @State private var selectedSchedule: ScheduleItem? = nil
    
    @State private var scrollTarget: Int? = nil
    @State private var userInteractionFlag: Bool = false
    
    @State private var floatingButtonPressed: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                VStack(spacing: 0) {
                    headerView()
                    
                    calendarView()
                        .background(Color.grayBlack)
                        .allowsHitTesting(userInteractionFlag)
                    
                    ScrollViewReader { proxy in
                        OffsetObservableScrollView(.horizontal,
                                                   showsIndicators: false,
                                                   scrollOffset: $viewModel.currentOffset,
                                                   content: { view in
                            LazyHStack(spacing: 0) {
                                ForEach(viewModel.mEventDataSource.eventList.indices, id: \.self) { index in
                                    let item = viewModel.mEventDataSource.eventList[index]
                                    
                                    dailyPageView(for: item)
                                        .frame(width: UIScreen.main.bounds.width)
                                        .id(index)
                                }
                            }
                        })
                        .onChange(of: scrollTarget) {
                            userInteractionFlag = false
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                userInteractionFlag = true
                                if let target = scrollTarget {
                                    withAnimation {
                                        proxy.scrollTo(target, anchor: .center)
                                    }
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                        .scrollContentBackground(.hidden)
                    }
                }
                .fullScreenCover(isPresented: $isSettingViewPresented) {
                    SettingView()
                        .environmentObject(settingViewModel)
                }
                .onChange(of: viewModel.selectedDate) {
                    updateScrollTarget()
                }
                .onAppear {
                    viewModel.getAllEvents()
                    viewModel.getSchedulesAllDay()
                    updateScrollTarget()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("postSchedule"))) { _ in
                    viewModel.getSchedulesTotal()
                    viewModel.getSchedulesAllDay()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("postToDo"))) { _ in
                    viewModel.getToDoListTotal()
                }
                .background(Color.grayBlack)
                
                FloatingButton(floatingButtonPressed: $floatingButtonPressed)
                
                if floatingButtonPressed {
                    NeonAnimationView(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            floatingButtonPressed = false
                        }
                    }
                }
            }
            .overlay {
                alertsView()
            }
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        if let date = viewModel.selectedDate.date() {
            HStack(spacing: 0) {
                Text("\(date.makeTodayMonthForMMM()) \(date.makeTodayDayString())")
                    .foregroundStyle(.white)
                    .applyFont(.suiteExtraBold(size: 32), lineHeight: 36)
                    .onTapGesture {
                        let today = Date()
                        viewModel.mCallendarDataSource.moveOtherWeekday(targetDate: today)
                        if let targetDateModel = today.makeTargetDate() {
                            viewModel.selectedDate = targetDateModel
                        }
                    }
                    .padding(.leading, 22)
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("\(date.makeTodayYearString())")
                        .foregroundStyle(Color.gray07)
                        .applyFont(.detail_b_12)
                        .padding(.top, 11)
                    
                    Spacer()
                }
                .padding(.trailing, 17)
                
                Button {
                    isSettingViewPresented = true
                } label: {
                    Image(.ic_settings)
                        .padding(.trailing, 25)
                }
            }
            .frame(height: 56)
        }
    }
    
    @ViewBuilder
    private func calendarView() -> some View {
        MHorizontalCalendar(horizontalCalendarAppearance: [.init(weekDay: .sun),
                                                           .init(weekDay: .mon),
                                                           .init(weekDay: .tue),
                                                           .init(weekDay: .wed),
                                                           .init(weekDay: .thu),
                                                           .init(weekDay: .fri),
                                                           .init(weekDay: .sat)],
                            mCallendarDatasource: viewModel.mCallendarDataSource,
                            selectedDateCompletion: { date in
            viewModel.selectedDate = date
        })
        .setWeekDayFont(MWeekDayOptions.allDays,
                        font: Font(MDSFont.suiteBold(size: 12).font))
        .setDayFont(MWeekDayOptions.allDays,
                    font: Font(MDSFont.suiteBold(size: 16).font))
        
        .setWeekDayTextColors(MWeekDayOptions.allDays,
                              color: .gray08)
        .setDayTextColors(MWeekDayOptions.allDays,
                          color: .gray06)
        
        .setWeekDaySelectedColor(MWeekDayOptions.allDays,
                                 color: .gray04)
        .setDaySelectedColor(MWeekDayOptions.allDays,
                             color: .grayBlack)
        
        .setDayBackgroundColors(MWeekDayOptions.allDays,
                                color: .clear)
        .setDaySelectedBackgroundColors(MWeekDayOptions.allDays,
                                        color: .gray04)
        
        .setTodayColor(color: .mainGreen)
    }
    
    @ViewBuilder
    private func dailyPageView(for item: MCalendarEventList) -> some View {
        VStack(spacing: 8) {
            AllDayListView(items: viewModel.allDayItems)
                .padding(.vertical, 4)
            
            TodayView(
                viewModel: viewModel,
                isToDoAlertPresented: $isToDoAlertPresented,
                isScheduleAlertPresented: $isScheduleAlertPresented,
                selectedToDo: $selectedToDo,
                selectedSchedule: $selectedSchedule
            )
            .scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder
    private func alertsView() -> some View {
        AlertOverlay(isPresented: isToDoAlertPresented, onDismiss: { isToDoAlertPresented = false }) {
            if let todo = selectedToDo {
                ToDoAlertView(
                    toDoId: todo.id,
                    toDoTitle: todo.description,
                    deadline: todo.endDate,
                    tagName: todo.tagName,
                    tagColorCode: todo.tagColor,
                    priority: todo.priorityType,
                    onDelete: {
                        viewModel.deleteToDo(toDoId: todo.id)
                        isToDoAlertPresented = false
                    },
                    onEdit: { isToDoAlertPresented = false },
                    isChecked: viewModel.bindingForToDoCompletion(todo.id)
                )
            }
        }
        
        AlertOverlay(isPresented: isScheduleAlertPresented, onDismiss: { isScheduleAlertPresented = false }) {
            if let schedule = selectedSchedule {
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
                        isScheduleAlertPresented = false
                    },
                    onEdit: { isScheduleAlertPresented = false }
                )
            }
        }
    }
    
    private func updateScrollTarget() {
        self.scrollTarget = (viewModel.mCallendarDataSource.currentIndex * 7) + viewModel.selectedDate.weekday.index
        
        if let scrollTarget {
            self.viewModel.currentOffset.x = Double(scrollTarget) * UIScreen.main.bounds.width
        }
    }
}
