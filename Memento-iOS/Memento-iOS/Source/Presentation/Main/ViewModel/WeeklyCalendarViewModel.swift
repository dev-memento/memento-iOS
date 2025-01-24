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
    
    // TODO: - Tag API 연결 후 주석 해제
    // @Published var schedules: [ScheduleTotalResponseData] = []
    @Published var schedules: [ScheduleTotalResponseDataTest] = []
    @Published var tag: [TagResponseData] = []
    @Published var allday: [ScheduleAllDayResponseDataTest] = []
    
    private let scheduleService: ScheduleAPIServiceProtocol
    private let tagService: TagAPIServiceProtocol
    
    init(mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource,
         scheduleService: ScheduleAPIServiceProtocol,
         tagService: TagAPIServiceProtocol) {
        
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        self.scheduleService = scheduleService
        self.tagService = tagService
        
        
        makeDummyEvent()
        addOffsetDebounce()
    }
    
    @Published var todayItems: [TodayItemDataModel] = []
    
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

extension WeeklyCalendarViewModel {
    func getSchedulesTotalAPI() {
        scheduleService.getSchedulesTotal { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let scheduleData = response?.data as? [ScheduleTotalResponseDataTest] {
                        // TODO: - Tag API 연결 후 주석 해제
                         self?.schedules = scheduleData
                        print(self?.schedules)
                    } else {
                        print("데이터변환 실패 ")
                        self?.schedules = []
                    }
                }
            default:
                print("ERROR")
            }
        }
    }
    
    func getTagsAPI() {
        tagService.getTags() { [weak self] result in
            switch result {
            case .success(let response):
                print("SUCCESS")
            default:
                print("ERROR")
            }
        }
    }
    
    func getSchedulesAllDayAPI() {
        scheduleService.getSchedulesAllDays { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let scheduleData = response?.data.allDaySchedulesList {
                        self?.allday = scheduleData
                    } else {
                        self?.allday = []
                    }
                }
            default:
                print("ERROR")
            }
        }
    }
}

extension WeeklyCalendarViewModel {
    func filterSchedules(for date: Date) {
        todayItems = schedules.filter { schedule in
            guard let startDate = schedule.startDate.toDate(),
                  let endDate = schedule.endDate.toDate() else {
                print("💔날짜 변환 실패 \(schedule)💔")
                return false
            }
            
            let isInRange = Calendar.current.isDate(date, inSameDayAs: startDate) ||
            (date > startDate && date < endDate) ||
            Calendar.current.isDate(date, inSameDayAs: endDate)
            
            if isInRange {
                print("💙일정이 \(schedule.description) 있지롱요💙")
            }
            return isInRange
        }.map { schedule in
            TodayItemDataModel.schedule(schedule)
        }
        print("💛선택한 날짜에 해당되는 일정 데이터 : \(todayItems)💛")
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
}


extension WeeklyCalendarViewModel {
    func onDateSelected(date: Date) {
        print("선택한 날짜: \(date)")
        filterSchedules(for: date)
    }
}
