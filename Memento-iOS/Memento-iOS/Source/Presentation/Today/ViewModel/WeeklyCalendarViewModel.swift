//
//  WeekluCalendarViewModel.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import Combine
import SwiftUI

import MDSKit
import MCalendar

final class WeeklyCalendarViewModel: ObservableObject {

    @Published var items: [TodayDataModel] = [
        .todo(ToDoListDataModel(colorType: "red", toDoTitle: "UXUI 과제", dueDate: "Today", priorityType: .immediate, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "green", scheduleTitle: "지금은새벽5시다", time: "12 PM - 4 PM", isCompleted: true)),
        .todo(ToDoListDataModel(colorType: "blue", toDoTitle: "독감조심하세요다들", dueDate: "Today", priorityType: .medium, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "orange", scheduleTitle: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", isCompleted: false)),
        .schedule(ScheduleListDataModel(colorType: "yellow", scheduleTitle: "나는지금배고프다", time: "2 PM - 3 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "blue", toDoTitle: "공차가너무먹고싶어요", dueDate: "Today", priorityType: .none, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "red", scheduleTitle: "하다보니깐6시다", time: "12 PM - 4 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "green", toDoTitle: "이것만하고자야징", dueDate: "Today", priorityType: .high, isChecked: false)),
        .todo(ToDoListDataModel(colorType: "orange", toDoTitle: "맥너겟어쩌고저쩌고", dueDate: "Today", priorityType: .low, isChecked: false))
    ]

    @Published var allDayItems: [AllDayListDataModel] = [
        .init(colorType: "red", allDayTitle: "박익범 가정방문 어쩌고저쩌고어쩌라고"),
        .init(colorType: "blue", allDayTitle: "지금은수요일새벽5시반"),
        .init(colorType: "green", allDayTitle: "마라샹궈먹었능데마싯다.."),
        .init(colorType: "orange", allDayTitle: "오늘커피6샷마심레전드"),
        .init(colorType: "red", allDayTitle: "보라매공원보라매공원보라매공원")
    ]

    @Published var dragItem: TodayDataModel?
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
    func dropAction(dragItem: TodayDataModel?, dropItem: TodayDataModel) {
        guard let dragItem,
              let toIndex = items.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = items.firstIndex(where: { $0.id == dragItem.id }) else { return }

        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
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
