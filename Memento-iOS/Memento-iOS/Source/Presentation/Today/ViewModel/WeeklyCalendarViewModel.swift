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

    @Published var items: [TodayItemDataModel] = [
        .todo(TodoDataModel(title: "UXUI 과제", dueDate: "Today", priority: .immediate, isChecked: false, tagColor: "red")),
        .schedule(ScheduleDataModel(title: "지금은새벽5시다", time: "12 PM - 4 PM", tagColor: "green", isCompleted: true)),
        .todo(TodoDataModel(title: "독감조심하세요다들", dueDate: "Today", priority: .medium, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", tagColor: "orange", isCompleted: false)),
        .schedule(ScheduleDataModel(title: "나는지금배고프다", time: "2 PM - 3 PM", tagColor: "yellow", isCompleted: true)),
        .todo(TodoDataModel(title: "공차가너무먹고싶어요", dueDate: "Today", priority: .none, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "하다보니깐6시다", time: "12 PM - 4 PM", tagColor: "red", isCompleted: false)),
        .todo(TodoDataModel(title: "이것만하고자야징", dueDate: "Today", priority: .high, isChecked: false, tagColor: "green")),
        .todo(TodoDataModel(title: "맥너겟어쩌고저쩌고", dueDate: "Today", priority: .low, isChecked: false, tagColor: "orange"))
    ]

    @Published var allDayItems: [AllDayDataModel] = [
        .init(colorType: "red", text: "박익범 가정방문 어쩌고저쩌고어쩌라고"),
        .init(colorType: "blue", text: "지금은수요일새벽5시반"),
        .init(colorType: "green", text: "마라샹궈먹었능데마싯다.."),
        .init(colorType: "orange", text: "오늘커피6샷마심레전드"),
        .init(colorType: "red", text: "보라매공원보라매공원보라매공원")
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
