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
    
    @Published var schedules: [ScheduleWithOrderInfos] = []
    @Published var tag: [TagResponse] = []
    @Published var toDoList: [ToDoGetResponses] = []
    @Published var allday: [AllDaySchedulesList] = []
    @Published var wakeUpTime: String = "8 AM"
    @Published var windDownTime: String = "11 PM"
    
    private let scheduleService: ScheduleAPIServiceProtocol
    private let tagService: TagAPIServiceProtocol
    private let toDoListService: ToDoListAPIServiceProtocol
    private let userUptimeService: UserUptimeAPIServiceProtocol
    
    init(mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource,
         scheduleService: ScheduleAPIServiceProtocol,
         tagService: TagAPIServiceProtocol,
         toDoListService: ToDoListAPIServiceProtocol,
         userUptimeService: UserUptimeAPIServiceProtocol) {
        
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        self.scheduleService = scheduleService
        self.tagService = tagService
        self.toDoListService = toDoListService
        self.userUptimeService = userUptimeService
        
        makeDummyEvent()
        addOffsetDebounce()
        bindSelectedDateSubject()
        setSendNotificationObserver()
        preProcessingForAllEvents()
    }
    
    deinit {
        removeObserver()
    }
    
    @Published var todayItems: [TodayItemDataModel] = []
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var allDayItems: [AllDayItem] = []
    @Published var toDoItems: [ToDoItem] = []
    @Published var toDoListDict: [MCalendarDataModel: [ToDoItem]] = [:]
    
    @Published var dragTodayItem: TodayItemDataModel?
    @Published var dragTodoItem: ToDoItem?
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
    
    @Published var getAllTodoList: Bool = false
    @Published var getAllScheduleList: Bool = false
    
    
    private let dateFormatter = DateFormatter()
    @Published var toDoListItemDict: [MCalendarDataModel: [ToDoItem]] = [:]
    
    private func preProcessingForAllEvents() {
        Publishers.CombineLatest($getAllTodoList, $getAllScheduleList)
            .filter { $0 && $1 }
            .sink { [weak self] _ in
                guard let self else { return }
                self.mapToTodayItemList()
            }
            .store(in: &cancellable)
    }
    
    func mapToTodayItemList() {
        //        todayItems = schedules.map { .schedule(
        //            .init(
        //                id: $0.id,
        //                description: $0.description,
        //                startDate: $0.startDate,
        //                endDate: $0.endDate,
        //                timeDuration: $0.timeDuration,
        //                isAllDay: $0.isAllDay,
        //                scheduleType: $0.scheduleType,
        //                order: $0.order,
        //                tagName: $0.tagName,
        //                tagColorCode: $0.tagColorCode
        //            )
        //        )}
        //        
        //        todayItems = toDoListItems.map {
        //            .todo(
        //                .init(
        //                    id: $0.id,
        //                    colorType: $0.colorType,
        //                    toDoTitle: $0.toDoTitle,
        //                    date: $0.date,
        //                    dueDate: $0.dueDate,
        //                    priorityType: $0.priorityType,
        //                    isChecked: $0.isChecked
        //                )
        //            )
        //        }
        getAllTodoList = false
        getAllScheduleList = false
    }
    
    func preprocessingForEventDate() {
        for date in mCallendarDataSource.wholeMonthDate {
            toDoListItemDict[date] = filteredTargetEvent(date)
        }
    }
    
    private func filteredTargetEvent(_ date: MCalendarDataModel) -> [ToDoItem] {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return toDoListItems.filter {
            dateFormatter.date(from: $0.startDate)! == date.date()!
        }
    }
    
    private func bindSelectedDateSubject() {
        $selectedDate
            .removeDuplicates()
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] newDate in
                guard let self else { return }
                if let date = newDate.date() {
                    self.onDateSelected(date: date)
                }
            })
            .store(in: &cancellable)
    }
    
    func setSendNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotification),
                                               name: .init("postScheduleComplete"),
                                               object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .init("postScheduleComplete"),
                                                  object: nil)
    }
    
    @objc
    private func didReceiveNotification() {
        
        self.getAllEvents()
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
    
    func dropActionForToDoList(dragItem: ToDoItem?, dropItem: ToDoItem) {
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
    
    // MARK: - toDoListDict Helpers
    
    private func mapToDoDictByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for date in mCallendarDataSource.wholeMonthDate {
            toDoListDict[date] = toDoItems.filter {
                dateFormatter.date(from: $0.startDate)! == date.date()!
            }
        }
    }
    
    private func removeToDoFromDict(toDoId: Int) {
        guard let date = toDoListDict.first(where: { $0.value.contains(where: { $0.id == toDoId }) })?.key,
              let index = toDoListDict[date]?.firstIndex(where: { $0.id == toDoId }) else { return }
        
        toDoListDict[date]?.remove(at: index)
        if toDoListDict[date]?.isEmpty == true {
            toDoListDict.removeValue(forKey: date)
        }
    }
    
    private func updateToDoCompletionInDict(toDoId: Int) {
        if let index = self.toDoItems.firstIndex(where: { $0.id == toDoId }) {
            self.toDoItems[index].isCompleted.toggle()
        }
        
        if let date = self.toDoListDict.first(where: { $0.value.contains(where: { $0.id == toDoId }) })?.key,
           let index = self.toDoListDict[date]?.firstIndex(where: { $0.id == toDoId }) {
            self.toDoListDict[date]?[index].isCompleted.toggle()
        }
    }
}

// MARK: - API

extension WeeklyCalendarViewModel {
    func getAllEvents() {
        getSchedulesTotal()
        getToDoListTotal()
    }
    
    func getSchedulesAllDay() {
        scheduleService.getSchedulesAllDay { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let allDayResponse = response?.data.allDaySchedulesList,
               !allDayResponse.isEmpty {
                
                DispatchQueue.main.async {
                    self.allDayItems = allDayResponse.map { AllDayItem(from: $0) }
                }
            }
        }
    }
    
    func getSchedulesTotal() {
        scheduleService.getSchedulesTotal { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let scheduleResponse = response?.data.scheduleWithOrderInfos, !scheduleResponse.isEmpty {
                
                DispatchQueue.main.async {
                    self.scheduleItems = scheduleResponse.map { ScheduleItem(from: $0) }
                    self.getAllScheduleList = true
                }
            }
        }
    }
    
    func deleteSchedule(scheduleId: Int) {
        scheduleService.deleteSchedule(scheduleId: scheduleId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if case .success = result {
                    if let index = self.todayItems.firstIndex(where: {
                        if case .schedule(let s) = $0 { return s.id == scheduleId }
                        return false
                    }) {
                        self.todayItems.remove(at: index)
                    }
                } else {
                    print("삭제 실패")
                }
            }
        }
    }
    
    func getToDoListTotal() {
        toDoService.getToDoListTotal { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let toDoResponse = response?.data.toDoGetResponses, !toDoResponse.isEmpty {
                
                DispatchQueue.main.async {
                    self.toDoItems = toDoResponse.map { ToDoItem(from: $0) }
                    self.mapToDoDictByDate()
                    self.getAllToDoList = true
                }
            }
        }
    }
    
    func updateToDoCompletion(toDoId: Int) {
        toDoService.updateToDoCompletion(toDoId: toDoId) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               response?.data != nil {
                
                DispatchQueue.main.async {
                    self.updateToDoCompletionInDict(toDoId: toDoId)
                }
            }
        }
    }
    
    func deleteToDo(toDoId: Int) {
        toDoService.deleteToDo(toDoId: toDoId) { [weak self] result in
            guard let self = self else { return }
            
            if case .success = result {
                DispatchQueue.main.async {
                    self.removeToDoFromDict(toDoId: toDoId)
                }
            }
        }
    }
    
    func userUptimeAPI() {
        //        userUptimeService.fetchUptime{ result in
        //            switch result {
        //            case .success(let response):
        //                print("시간 가져오기 성공")
        //                // 추가 작업 필요 시 여기에 작성
        //                if let wakeUpTime = response?.data.wakeUpTime, let windDownTime = response?.data.windDownTime {
        //                    self.wakeUpTime = wakeUpTime
        //                    self.windDownTime = wakeUpTime
        //                    print("시간 가져오기 성공 \(self.wakeUpTime) \(self.windDownTime)")
        //                } else {
        //                    self.wakeUpTime = "8 AM"
        //                    self.windDownTime = "11 PM"
        //                }
        //            default:
        //                print("시간 가져오기 실패")
        //            }
        //        }
    }
}

extension Date {
    /// 예) 2025-01-12 15:00 이면 → 2025-01-12 23:59:59
    var endOfDay: Date {
        let start = self.startOfDay
        // start + 1일 - 1초 (즉 다음날 0시 직전)
        return Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: start)!
    }
}

extension WeeklyCalendarViewModel {
    func filterSchedules(for date: Date) {
        todayItems = []
        // 1) "하루의 시작"과 "하루의 끝" 구하기
        let dayStart = date.startOfDay
        let dayEnd = date.endOfDay
        
        // 2) schedules 배열에서 일정이 하루라도 겹치는 것만 필터링
        let scheudle = schedules.filter { schedule in
            guard
                let start = toDateFromString(schedule.startDate),
                let end   = toDateFromString(schedule.endDate)
            else {
                print("💔날짜 변환 실패 \(schedule)💔")
                return false
            }
            
            // 3) 일정이 [dayStart, dayEnd] 범위와 겹치는지 확인
            //    일정의 시작 ≤ dayEnd && 일정의 끝 ≥ dayStart
            return start <= dayEnd && end >= dayStart
        }
            .map {
                TodayItemDataModel.schedule(
                    .init(
                        id: $0.id,
                        description: $0.description,
                        startDate: $0.startDate,
                        endDate: $0.endDate,
                        timeDuration: $0.timeDuration,
                        isAllDay: $0.isAllDay,
                        scheduleType: $0.scheduleType,
                        order: $0.order,
                        tagName: $0.tagName,
                        tagColorCode: $0.tagColorCode
                    )
                )
            }
        
        let today = toDoListItems.filter { todoItem in
            guard
                let start = makeDateToString(todoItem.startDate),
                let end   = makeDateToString(todoItem.endDate)
            else {
                print("💔날짜 변환 실패 \(todoItem)💔")
                return false
            }
            
            // 3) 일정이 [dayStart, dayEnd] 범위와 겹치는지 확인
            //    일정의 시작 ≤ dayEnd && 일정의 끝 ≥ dayStart
            return start <= dayEnd && end >= dayStart
        }
//            .map {
//                TodayItemDataModel
//                    .todo(
//                        ToDoItem(
//                            id: $0.id,
//                            description: $0.description,
//                            startDate: $0.startDate,
//                            endDate: $0.endDate,
//                            isCompleted: $0.isCompleted,
//                            priorityType: Priority(rawValue: $0.priorityType.lowercased()) ?? .none,
//                            tagName: $0.tagName,
//                            tagColor: $0.tagColor,
//                            toDoType: $0.toDoType
//                        )
//                    )
//            }

        todayItems.append(contentsOf: scheudle)
//        todayItems.append(contentsOf: today)
    }
    
    private func toDateFromString(_ date: String) -> Date? {
        if let date1 = date.toDate() {
            return date1
        } else {
            if let date2 = date.toDateForNotContainMiliseconds() {
                return date2
            } else {
                return nil
            }
        }
    }
    
    private func makeDateToString(_ date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.date(from: self)
    }
    
    func toDateForNotContainMiliseconds() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: self)
    }
}


extension WeeklyCalendarViewModel {
    func onDateSelected(date: Date) {
        print("선택한 날짜: \(date)")
        filterSchedules(for: date)
    }
}
