//
//  TabBarItem.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/7/25.
//

import SwiftUI

import MCalendar

enum TabBarItem: CaseIterable {
    
    case today, todo, addition
    
    // 선택되지 않은 탭
    var normalItem: Image? {
        switch self {
        case .today:
            return Image(systemName: "calendar")
        case .todo:
            return Image(systemName: "calendar")
        case .addition:
            return Image(systemName: "calendar")
        }
    }
    
    // 선택된 탭
    var selectedItem: Image? {
        switch self {
        case .today:
            return Image(systemName: "calendar")
        case .todo:
            return Image(systemName: "calendar")
        case .addition:
            return Image(systemName: "calendar")
        }
    }
    
    
    // 탭 별 전환될 화면
    var targetView: AnyView {
        switch self {
        case .today:
            return AnyView(TodayWeeklyCalendarView(viewModel: WeeklyCalendarViewModel(
                        mCalendarDataSource: MCalendarDataSource(),
                        mEventDataSource: MEventDatasource(),
                        scheduleService: ScheduleAPIService()
                    )))
        case .todo:
            return AnyView(TodayWeeklyCalendarView(viewModel: WeeklyCalendarViewModel(
                        mCalendarDataSource: MCalendarDataSource(),
                        mEventDataSource: MEventDatasource(),
                        scheduleService: ScheduleAPIService()
                    )))
        case .addition:
            return AnyView(TodayWeeklyCalendarView(viewModel: WeeklyCalendarViewModel(
                        mCalendarDataSource: MCalendarDataSource(),
                        mEventDataSource: MEventDatasource(),
                        scheduleService: ScheduleAPIService()
                    )))
        }
    }
}
