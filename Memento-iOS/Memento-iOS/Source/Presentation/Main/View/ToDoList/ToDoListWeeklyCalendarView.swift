//
//  ToDoListWeeklyCalendarView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/18/25.
//

import SwiftUI
import MDSKit
import MCalendar

struct ToDoListWeeklyCalendarView: View {
    
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    @StateObject private var settingViewModel = SettingViewModel()
    
    @State private var isToDoAlertPresented = false
    @State private var isSettingViewPresented = false
    
    @State private var selectedItem: ToDoItem? = nil
    @State private var scrollTarget: MCalendarDataModel? = nil
    
    @State private var floatingButtonPressed: Bool = false
    
    var editAction: (ToDoItem) -> Void
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                VStack(spacing: 0) {
                    headerView()
                    
                    calendarView()
                        .background(Color.grayBlack)
                    
                    ScrollViewReader { proxy in
                        ToDoListView(viewModel: viewModel) { tappedItem in
                            selectedItem = tappedItem
                            isToDoAlertPresented = true
                        }
                        .scrollContentBackground(.hidden)
                        .padding(.vertical, 4)
                        .onChange(of: scrollTarget) {
                            withAnimation {
                                proxy.scrollTo(scrollTarget, anchor: .top)
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $isSettingViewPresented) {
                    SettingView()
                        .environmentObject(settingViewModel)
                }
                .onChange(of: viewModel.selectedDate) {
                    scrollTarget = viewModel.selectedDate
                }
                .onAppear {
                    DispatchQueue.main.async {
                        scrollTarget = viewModel.selectedDate
                    }
                    
                    viewModel.getToDoListTotal(
                        useCache: true
                    )
                    viewModel.getSchedulesTotal(
                        useCache: true
                    )
                }
                .background(Color.grayBlack)
                
                FloatingButton(floatingButtonPressed: $floatingButtonPressed)
                
                if floatingButtonPressed {
                    GeometryReader { geo in
                        NeonAnimationView(
                            width: geo.size.width,
                            height: geo.size.height
                        )
                        .onAppear {
                            viewModel.fetchDailyPrioritization()

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                floatingButtonPressed = false
                            }
                        }
                    }
                }
            }
            .overlay {
                alertView()
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
    private func alertView() -> some View {
        AlertOverlay(isPresented: isToDoAlertPresented, onDismiss: {
            isToDoAlertPresented = false
        }) {
            if let item = selectedItem {
                ToDoAlertView(
                    toDoId: item.id,
                    toDoTitle: item.description,
                    deadline: item.endDate,
                    tagName: item.tagName,
                    tagColorCode: item.tagColor,
                    priority: item.priorityType,
                    onDelete: {
                        viewModel.deleteToDo(toDoId: item.id)
                        isToDoAlertPresented = false
                    },
                    onEdit: {
                        isToDoAlertPresented = false
                        editAction(item)
                    },
                    isChecked: viewModel.bindingForToDoCompletion(item.id)
                )
            }
        }
    }
}
