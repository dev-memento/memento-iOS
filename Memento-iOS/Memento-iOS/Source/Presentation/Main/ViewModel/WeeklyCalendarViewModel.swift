//
//  WeeklyCalendarViewModel.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import Combine
import SwiftUI

import MDSKit
import MCalendar

final class WeeklyCalendarViewModel: ObservableObject {
    @Published var allDayItems: [AllDayListDataModel] = [
        .init(colorType: "mementoRed", allDayTitle: "박익범 가정방문 어쩌고저쩌고어쩌라고"),
        .init(colorType: "mementoOrange", allDayTitle: "지금은수요일새벽5시반"),
        .init(colorType: "mementoLightGreen", allDayTitle: "마라샹궈먹었능데마싯다.."),
        .init(colorType: "mementoOrange", allDayTitle: "오늘커피6샷마심레전드"),
        .init(colorType: "mementoMint", allDayTitle: "보라매공원보라매공원보라매공원")
    ]
    
    @Published var todayItems: [TodayItemDataModel] = [
        .todo(ToDoListDataModel(colorType: "mementoRed", toDoTitle: "투두1", dueDate: "Today", priorityType: .immediate, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoPurple", scheduleTitle: "스케줄1", time: "12 PM - 4 PM", isCompleted: true)),
        .todo(ToDoListDataModel(colorType: "mementoBlue", toDoTitle: "투두2", dueDate: "Today", priorityType: .medium, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoCyan", scheduleTitle: "스케줄2", time: "2 PM - 3 PM", isCompleted: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoOrange", scheduleTitle: "스케줄3", time: "2 PM - 3 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "mementoYellow", toDoTitle: "투두3", dueDate: "Today", priorityType: .high, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoBlue", scheduleTitle: "스케줄4", time: "12 PM - 4 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "mementoLightGreen", toDoTitle: "투두4", dueDate: "Today", priorityType: .none, isChecked: false)),
        .todo(ToDoListDataModel(colorType: "mementoMint", toDoTitle: "투두5", dueDate: "Today", priorityType: .low, isChecked: false))
    ]
    
    @Published var toDoListItems: [String: [ToDoListDataModel]] = [
        "Jan 3": [
            ToDoListDataModel(colorType: "mementoRed", toDoTitle: "투두1", dueDate: "Today", priorityType: .immediate, isChecked: false),
            ToDoListDataModel(colorType: "mementoBlue", toDoTitle: "투두2", dueDate: "Today", priorityType: .medium, isChecked: false),
            ToDoListDataModel(colorType: "mementoYellow", toDoTitle: "투두3", dueDate: "Today", priorityType: .high, isChecked: false),
            ToDoListDataModel(colorType: "mementoLightGreen", toDoTitle: "투두4", dueDate: "Today", priorityType: .none, isChecked: false)
        ],
        "Jan 4": [],
        "Jan 5": [
            ToDoListDataModel(colorType: "mementoPink", toDoTitle: "투두5", dueDate: "Today", priorityType: .immediate, isChecked: false)
        ]
    ]
    
    @Published var dragItem: TodayItemDataModel?
    @Published var dropIndex: Int?
    
    @Published var mCallendarDataSource: MCalendarDataSource
    @Published var mEventDataSource: MEventDatasource
    @Published var currentIndex: Int = 1
    @Published var currentOffset: CGPoint = .zero
    @Published var selectedDate: MCalendarDataModel = .init(year: "2025",
                                                            month: "1",
                                                            day: "10",
                                                            weekday: .fri)
    
    private var cancellable = Set<AnyCancellable>()
    
    init(mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource) {
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        
        makeDummyEvent()
        addOffsetDebounce()
    }
}

extension WeeklyCalendarViewModel {
    func dropAction(dragItem: TodayItemDataModel?, dropItem: TodayItemDataModel) {
        guard let dragItem,
              let toIndex = todayItems.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = todayItems.firstIndex(where: { $0.id == dragItem.id }) else { return }
        
        withAnimation {
            todayItems.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
    
    func makeDummyEvent() {
        mEventDataSource.setCalendarData(mCallendarDataSource.wholeMonthDate)
    }
    
    private func addOffsetDebounce() {
        $currentOffset
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink { [weak self] offset in
                guard let self else { return }
                let index = Int(offset.x / UIScreen.main.bounds.width)
                self.selectedDate = self.mEventDataSource.eventList[index].dateModel
                if let date = self.mEventDataSource.eventList[index].dateModel.date() {
                    self.mCallendarDataSource.moveOtherWeekday(targetDate: date)
                }
            }
            .store(in: &cancellable)
    }
}
