//
//  WeeklyCalendarView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import SwiftUI

import MDSKit
import MCalendar

struct WeeklyCalendarView: View {
    
    @ObservedObject var viewModel: WeeklyCalendarViewModel

    //Scroll value
    @State private var scrollTarget: Int? = nil
    @State private var userInteractionFlag: Bool = false

    
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
                                makeIndex()
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
                .allowsHitTesting(userInteractionFlag)
            
            ScrollViewReader { proxy in
                OffsetObservableScrollView(.horizontal,
                                           showsIndicators: false,
                                           scrollOffset: $viewModel.currentOffset,
                                           content: { view in
                    LazyHStack(spacing: 0) {
                        ForEach(viewModel.mEventDataSource.eventList.indices, id: \.self) { index in
                            let item = viewModel.mEventDataSource.eventList[index]
                            todoItem(item: item)
                                .frame(width: UIScreen.main.bounds.width)
                                .id(index)
                        }
                    }
                })
                .onChange(of: scrollTarget) {
                    userInteractionFlag = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
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
        .onAppear {
            //make event
            viewModel.makeDummyEvent()
            makeIndex()
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
    
    @ViewBuilder
    private func todoItem(item: MCalendarEventList) -> some View {
        ScrollView(.vertical) {
            TodayListView()
        }
        .scrollContentBackground(.hidden)
    }
    
    private func makeIndex() {
        self.scrollTarget = (viewModel.mCallendarDataSource.currentIndex * 7) + viewModel.selectedDate.weekday.index
        if let scrollTarget {
            self.viewModel.currentOffset.x = Double(scrollTarget) * UIScreen.main.bounds.width
        }
    }
}

#Preview {
    WeeklyCalendarView(viewModel: .init(mCalendarDataSource: MCalendarDataSource(),
                                 mEventDataSource: MEventDatasource()))
}
