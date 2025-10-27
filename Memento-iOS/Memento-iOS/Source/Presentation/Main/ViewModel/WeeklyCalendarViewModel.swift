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
    
    // MARK: - Dependencies
    
    private let scheduleService: ScheduleAPIServiceProtocol
    private var toDoService: ToDoListAPIServiceProtocol
    private let userUptimeService: UserUptimeAPIServiceProtocol
    private let prioritizationService: PrioritizationAPIServiceProtocol
    
    // MARK: - Published Properties
    
    @Published var mCallendarDataSource: MCalendarDataSource
    @Published var mEventDataSource: MEventDatasource
    
    @Published private(set) var todayItems: [TodayItem] = []
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var allDayItems: [AllDayItem] = []
    @Published private(set) var allDayDict: [MCalendarDataModel: [AllDayItem]] = [:]
    
    @Published var toDoItems: [ToDoItem] = []
    @Published private(set) var toDoListDict: [MCalendarDataModel: [ToDoItem]] = [:]
    
    @Published var isFirstFetch: Bool = true
    
    @Published var wakeUpTime: String = ""
    @Published var windDownTime: String = ""
    
    @Published var currentOffset: CGPoint = .zero
    @Published var selectedDate: MCalendarDataModel = Date().makeTargetDate()!
    @Published var isInitialScrollDone = false
    
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(scheduleService: ScheduleAPIServiceProtocol,
         toDoService: ToDoListAPIServiceProtocol,
         userUptimeService: UserUptimeAPIServiceProtocol,
         prioritizationService: PrioritizationAPIServiceProtocol,
         mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource
    ) {
        self.scheduleService = scheduleService
        self.toDoService = toDoService
        self.userUptimeService = userUptimeService
        self.prioritizationService = prioritizationService
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        
        makeDummyEvent()
        setupBindings()
        updateSelectedDate()
        
        TagManager.shared.fetchAndSaveTags { success in
            print(success ? "태그 동기화 완료" : "태그 동기화 실패")
        }
    }
    
    private func makeDummyEvent() {
        mEventDataSource.setCalendarData(mCallendarDataSource.wholeMonthDate)
    }
    
    // MARK: - Drag & Drop
    
    @Published var dragTodayItem: TodayItem?
    @Published var dragTodoItem: ToDoItem?
    @Published var dropIndex: Int?
    
    // MARK: - Combine (Binding Items)
    
    private func setupBindings() {
        bindTodayItems()
        bindAllDayDict()
        bindToDoDict()
    }
    
    private func bindTodayItems() {
        Publishers.CombineLatest3($scheduleItems, $toDoItems, $selectedDate)
            .map { schedules, todos, selectedDate -> [TodayItem] in
                guard let currentDate = selectedDate.date() else { return [] }
                
                let dayStart = currentDate.startOfDay
                let dayEnd = currentDate.endOfDay
                var todayItems: [TodayItem] = []
                
                schedules.forEach { schedule in
                    guard let start = Date.dateFromScheduleString(schedule.startDate),
                          let end = Date.dateFromScheduleString(schedule.endDate),
                          start <= dayEnd, end >= dayStart else { return }
                    todayItems.append(.schedule(schedule))
                }
                
                todos.forEach { todo in
                    guard let start = Date.dateFromString(todo.startDate, format: "yyyy-MM-dd"),
                          let end = Date.dateFromString(todo.endDate, format: "yyyy-MM-dd"),
                          start <= dayEnd, end >= dayStart else { return }
                    todayItems.append(.todo(todo))
                }
                
                return todayItems
            }
            .assign(to: &$todayItems)
    }
    
    private func bindAllDayDict() {
        Publishers.CombineLatest($allDayItems, $mCallendarDataSource)
            .map { allDayItems, calendarDataSource -> [MCalendarDataModel: [AllDayItem]] in
                var allDayDict: [MCalendarDataModel: [AllDayItem]] = [:]
                for date in calendarDataSource.wholeMonthDate {
                    guard let currentDate = date.date() else { continue }
                    
                    let dayStart = currentDate.startOfDay
                    let dayEnd = currentDate.endOfDay
                    
                    allDayDict[date] = allDayItems.filter { item in
                        guard let start = Date.dateFromScheduleString(item.startDate),
                              let end = Date.dateFromScheduleString(item.endDate) else { return false }
                        return start <= dayEnd && end >= dayStart
                    }
                }
                
                return allDayDict
            }
            .assign(to: &$allDayDict)
    }
    
    private func bindToDoDict() {
        Publishers.CombineLatest($toDoItems, $mCallendarDataSource)
            .map { todos, calendarDataSource -> [MCalendarDataModel: [ToDoItem]] in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                var toDoDict: [MCalendarDataModel: [ToDoItem]] = [:]
                for date in calendarDataSource.wholeMonthDate {
                    guard let currentDate = date.date() else { continue }
                    
                    var items = todos.filter { formatter.date(from: $0.startDate) == currentDate }
                    
                    let incompletes = items.filter { !$0.isCompleted }
                    let completes = items.filter { $0.isCompleted }
                        .sorted { ($0.completedAt ?? .distantPast) < ($1.completedAt ?? .distantPast) }
                    
                    items = incompletes + completes
                    toDoDict[date] = items
                }
                
                return toDoDict
            }
            .assign(to: &$toDoListDict)
    }
    
    // MARK: - Selected Date Scroll
    
    private func updateSelectedDate() {
        $currentOffset
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .sink { [weak self] offset in
                guard let self else { return }
                if !isInitialScrollDone { return }
                
                let index = Int(offset.x / UIScreen.main.bounds.width)
                self.selectedDate = self.mEventDataSource.eventList[index].dateModel
                
                if let date = self.mEventDataSource.eventList[index].dateModel.date() {
                    self.mCallendarDataSource.moveOtherWeekday(targetDate: date)
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - Items Handling

extension WeeklyCalendarViewModel {
    
    // ToDo Completion UI와 연결
    func bindingForToDoCompletion(_ toDoId: Int) -> Binding<Bool> {
        Binding<Bool>(
            get: {
                if let date = self.toDoListDict.first(where: { $0.value.contains(where: { $0.id == toDoId }) })?.key,
                   let index = self.toDoListDict[date]?.firstIndex(where: { $0.id == toDoId }) {
                    return self.toDoListDict[date]?[index].isCompleted ?? false
                }
                return false
            },
            set: { _ in
                self.updateToDoCompletion(toDoId: toDoId)
            }
        )
    }
    
    // ToDo Completion 데이터와 캐시 갱신
    private func updateToDoCompletionInDict(toDoId: Int) {
        if let index = self.toDoItems.firstIndex(where: { $0.id == toDoId }) {
            self.toDoItems[index].isCompleted.toggle()
            
            if self.toDoItems[index].isCompleted {
                self.toDoItems[index].completedAt = Date()
            } else {
                self.toDoItems[index].completedAt = nil
            }
        }
        
        ToDoCache.shared.set(key: "todos", data: self.toDoItems)
    }
    
    
    func isTopPriorityItem(item: TodayItem) -> Bool {
        guard case .todo(let todo) = item, !todo.isCompleted else { return false }
        
        let incompleteTodos = todayItems.compactMap {
            if case .todo(let t) = $0, !t.isCompleted { return t }
            return nil
        }
        return incompleteTodos.first?.id == todo.id
    }
    
    func isTopPriorityItem(at item: ToDoItem, items: [ToDoItem]) -> Bool {
        guard !item.isCompleted else { return false }
        
        let incompleteItems = items.filter { !$0.isCompleted }
        
        return incompleteItems.first?.id == item.id
    }
}

// MARK: - API

extension WeeklyCalendarViewModel {
    
    func getAllEvents(useCache: Bool = true) {
        getSchedulesTotal(useCache: useCache)
        getToDoListTotal(useCache: useCache)
    }
    
    // MARK: - Schedule
    
    func getSchedulesTotal(useCache: Bool = true) {
        let start = Date()
        
        // 캐시 사용
        if useCache, let cached = ScheduleCache.shared.get(key: "schedules") {
            DispatchQueue.main.async {
                self.scheduleItems = cached
            }
            
            APICacheLogger.shared.logCacheCall(start: start, apiName: "Schedule")
            
            return
        }
        
        scheduleService.getSchedulesTotal { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if case let .success(response) = result,
                   let scheduleResponse = response?.data.scheduleWithOrderInfos {
                    self.scheduleItems = scheduleResponse.map { ScheduleItem(from: $0) }
                    
                    ScheduleCache.shared.set(key: "schedules", data: self.scheduleItems)
                }
            }
            
            APICacheLogger.shared.logServerCall(start: start, apiName: "Schedule")
        }
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
    
    //    func getSchedulesByDate() {
    //        guard let date = selectedDate.date() else { return }
    //        let targetDate = date.stringFromDate(with: "yyyy-MM-dd")
    //
    //        scheduleService.getSchedulesByDate(date: targetDate) { [weak self] result in
    //            guard let self else { return }
    //
    //            if case let .success(response) = result,
    //               let scheduleResponse = response?.data.scheduleWithOrderInfos {
    //
    //                let mapped = scheduleResponse.map { ScheduleItem(from: $0) }
    //                DispatchQueue.main.async {
    //                    self.scheduleItems = mapped
    //                    if let date = self.selectedDate.date() {
    //                        self.updateTodayItems(for: date)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func deleteSchedule(scheduleId: Int) {
        scheduleService.deleteSchedule(scheduleId: scheduleId) { [weak self] result in
            guard let self = self else { return }
            
            if case .success = result {
                DispatchQueue.main.async {
                    self.scheduleItems.removeAll { $0.id == scheduleId }
                }
            }
        }
    }
    
    // MARK: - ToDo
    
    func getToDoListTotal(useCache: Bool = true) {
        let start = Date()
        
        // 캐시 사용
        if useCache, let cached = ToDoCache.shared.get(key: "todos") {
            DispatchQueue.main.async {
                self.toDoItems = cached
            }
            
            APICacheLogger.shared.logCacheCall(start: start, apiName: "ToDo")
            
            return
        }
        
        toDoService.getToDoListTotal { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if case let .success(response) = result,
                   let toDoResponse = response?.data.toDoGetResponses {
                    self.toDoItems = toDoResponse.map { ToDoItem(from: $0) }
                    
                    ToDoCache.shared.set(key: "todos", data: self.toDoItems)
                }
            }
            
            APICacheLogger.shared.logServerCall(start: start, apiName: "ToDo")
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
                    self.toDoItems.removeAll { $0.id == toDoId }
                }
            }
        }
    }
    
    // MARK: - etc
    
    func fetchDailyPrioritization() {
        guard let date = selectedDate.date() else {
            return
        }
        
        let targetDate = date.stringFromDate(with: "yyyy-MM-dd")
        
        let body = PrioritizationRequest(targetDate: targetDate)
        
        prioritizationService.fetchDailyPrioritization(body: body) { result in
            if case let .success(response) = result,
               let todos = response?.data.todos {
                print("Success: ", todos)
            } else {
                print("Fail")
            }
        }
    }
    
    func getUserUptime() {
        userUptimeService.getUserUptime { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let data = response?.data {
                self.wakeUpTime = data.wakeUpTime
                self.windDownTime = data.windDownTime
            }
        }
    }
}
