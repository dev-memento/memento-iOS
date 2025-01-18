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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let date = viewModel.selectedDate.date() {
                    Text("\(date.makeTodayMonthForMMM()) \(date.makeTodayDayString())") // Jan 14
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
                        Text("\(date.makeTodayYearString())") // 2025
                            .foregroundStyle(Color.gray07)
                            .applyFont(.detail_b_12)
                            .padding(.top, 11)
                        Spacer()
                    }
                    .padding(.trailing, 17)
                    Image(.ic_settings)
                        .resizable()
                        .frame(width: 26, height: 26)
                        .padding(.trailing, 34)
                }
            }
            .frame(height: 56)
            
            calendarView()
                .background(Color.grayBlack)
            
            ToDoListView(viewModel: viewModel)
                .scrollContentBackground(.hidden)
                .padding(.vertical, 4)
        }
        .onAppear {
            viewModel.makeDummyEvent()
        }
        .background(Color.grayBlack)
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
}

#Preview {
    ToDoListWeeklyCalendarView(viewModel: WeeklyCalendarViewModel(
        mCalendarDataSource: MCalendarDataSource(),
        mEventDataSource: MEventDatasource()
    ))
}
