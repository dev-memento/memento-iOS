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
        .init(colorType: "mementoRed", allDayTitle: "김가현 땅스부대찌개에서 부대찌개 사오고 자기가 하나부터 열까지 다 끌ㅎ인척하던데 진짜 양심이 있는거냐 미친거야 미친거냐 미친거임?미친걸까 미친 ㅋㅋ "),
        .init(colorType: "mementoOrange", allDayTitle: "지금은수요일새벽5시반"),
        .init(colorType: "mementoLightGreen", allDayTitle: "마라샹궈먹었능데마싯다.."),
        .init(colorType: "mementoOrange", allDayTitle: "오늘커피6샷마심레전드"),
        .init(colorType: "mementoMint", allDayTitle: "보라매공원보라매공원보라매공원")
    ]
    
    @Published var todayItems: [TodayItemDataModel] = [
        .todo(ToDoListDataModel(colorType: "mementoRed", toDoTitle: "투두1", dueDate: "Today", priorityType: .immediate, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoPurple", scheduleTitle: "스케줄1", startTime: "12 PM", endTime: "- 4 PM", isCompleted: true)),
        .todo(ToDoListDataModel(colorType: "mementoBlue", toDoTitle: "투두2", dueDate: "Today", priorityType: .medium, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoCyan", scheduleTitle: "스케줄2", startTime: "12 PM", endTime: "- 4 PM", isCompleted: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoOrange", scheduleTitle: "스케줄3", startTime: "12 PM", endTime: "- 4 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "mementoYellow", toDoTitle: "투두3", dueDate: "Today", priorityType: .high, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "mementoBlue", scheduleTitle: "스케줄4", startTime: "12 PM", endTime: "- 4 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "mementoLightGreen", toDoTitle: "투두4", dueDate: "Today", priorityType: .none, isChecked: false)),
        .todo(ToDoListDataModel(colorType: "mementoMint", toDoTitle: "투두5", dueDate: "Today", priorityType: .low, isChecked: false))
    ]
    
    @Published var toDoListItems: [ToDoListDataModel] = [
        ToDoListDataModel(colorType: "mementoRed", toDoTitle: "투두1", dueDate: "Today", priorityType: .immediate, isChecked: false),
        ToDoListDataModel(colorType: "mementoBlue", toDoTitle: "투두2", dueDate: "Today", priorityType: .medium, isChecked: false),
        ToDoListDataModel(colorType: "mementoYellow", toDoTitle: "투두3", dueDate: "Today", priorityType: .high, isChecked: false),
        ToDoListDataModel(colorType: "mementoLightGreen", toDoTitle: "투두4", dueDate: "Today", priorityType: .none, isChecked: false),
        ToDoListDataModel(colorType: "mementoPink", toDoTitle: "투두5", dueDate: "Today", priorityType: .immediate, isChecked: false)
    ]
    
    @Published var dragTodayItem: TodayItemDataModel?
    @Published var dragTodoItem: ToDoListDataModel?
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
    func dropActionForToday(dragItem: TodayItemDataModel?, dropItem: TodayItemDataModel) {
        guard let dragItem,
              let dropIndex = todayItems.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = todayItems.firstIndex(where: { $0.id == dragItem.id }),
              case .todo = dragItem else { return }
        
        todayItems.move(fromOffsets: IndexSet(integer: fromIndex),
                        toOffset: dropIndex > fromIndex ? dropIndex + 1 : dropIndex)
    }
    
    func dropActionForToDoList(dragItem: ToDoListDataModel?, dropItem: ToDoListDataModel) {
        guard let dragItem,
              let dropIndex = toDoListItems.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = toDoListItems.firstIndex(where: { $0.id == dragItem.id }) else { return }
        
        toDoListItems.move(fromOffsets: IndexSet(integer: fromIndex),
                           toOffset: dropIndex > fromIndex ? dropIndex + 1 : dropIndex)
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
