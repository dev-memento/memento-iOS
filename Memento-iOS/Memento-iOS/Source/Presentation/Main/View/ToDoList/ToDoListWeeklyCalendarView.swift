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
    @ObservedObject var viewModel: ToDoListViewModel
    @StateObject private var settingViewModel = SettingViewModel()
    @State private var scrollTarget: MCalendarDataModel? = nil
    @State private var userInteractionFlag: Bool = false
    @State private var isSettingPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if let date = viewModel.selectedDate.date() {
                        Text("\(date.makeTodayMonthForMMM()) \(date.makeTodayDayString())")
                            .foregroundStyle(.white)
                            .applyFont(.suiteExtraBold(size: 32),
                                       lineHeight: 36)
                            .onTapGesture {
                                let date = Date()
                                viewModel.mCallendarDataSource.moveOtherWeekday(targetDate: date)
                                if let targetDateModel = date.makeTargetDate() {
                                    viewModel.selectedDate = targetDateModel
                                }
                            }
                            .padding(.leading, 22)
                        Spacer()
                        VStack {
                            Text("\(date.makeTodayYearString())")
                                .foregroundStyle(Color.gray07)
                                .applyFont(.detail_b_12)
                                .padding(.top, 11)
                            Spacer()
                        }
                        .padding(.trailing, 17)
                        Button {
                            isSettingPresented = true
                        } label: {
                            Image(.ic_settings)
                                .resizable()
                                .frame(width: 26, height: 26)
                                .padding(.trailing, 34)
                        }
                    }
                }
                .frame(height: 56)
                
                calendarView()
                    .background(Color.grayBlack)
                
                ScrollViewReader { proxy in
                    ToDoListView(viewModel: viewModel)
                        .scrollContentBackground(.hidden)
                        .padding(.vertical, 4)
                        .onChange(of: scrollTarget) {
                            withAnimation {
                                proxy.scrollTo(scrollTarget, anchor: .top)
                            }
                        }
                }
            }
            .fullScreenCover(isPresented: $isSettingPresented) {
                SettingView()
                    .environmentObject(settingViewModel)
            }
            .onAppear {
                makeIndex()
            }
            .background(Color.grayBlack)
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
            makeIndex()
        })
        .setWeekDayFont(MWeekDayOptions.allDays,
                        font: Font(MDSFont.suiteBold(size: 12).font))
        .setWeekDayTextColors(MWeekDayOptions.allDays,
                              color: .gray08)
        .setWeekDaySelectedColor(MWeekDayOptions.allDays,
                                 color: .gray04)
        .setDayFont(MWeekDayOptions.allDays,
                    font: Font(MDSFont.suiteBold(size: 16).font))
        .setDayBackgroundColors(MWeekDayOptions.allDays,
                                color: .grayWhite)
        .setDayBackgroundColors(MWeekDayOptions.allDays,
                                color: .clear)
        .setDayTextColors(MWeekDayOptions.allDays,
                          color: .gray06)
        .setDaySelectedColor(MWeekDayOptions.allDays,
                             color: .grayBlack)
        .setDaySelectedBackgroundColors(MWeekDayOptions.allDays,
                                        color: .gray04)
        .setTodayColor(color: .mainGreen)
    }
    
    private func makeIndex() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            scrollTarget = viewModel.selectedDate
        }
    }
}
