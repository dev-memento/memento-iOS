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
    
    @Published var todayItems: [TodayItem] = []
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var allDayItems: [AllDayItem] = []
    @Published var allDayDict: [MCalendarDataModel: [AllDayItem]] = [:]
    @Published var toDoItems: [ToDoItem] = []
    @Published var toDoListDict: [MCalendarDataModel: [ToDoItem]] = [:]
    
    @Published var wakeUpTime: String = "8 AM"
    @Published var windDownTime: String = "11 PM"
    
    @Published var currentOffset: CGPoint = .zero
    @Published var selectedDate: MCalendarDataModel = Date().makeTargetDate()! {
        didSet {
            if let date = selectedDate.date() {
                updateTodayItems(for: date)
            }
        }
    }
    @Published var isInitialScrollDone = false
    
    @Published var getAllToDoList: Bool = false
    @Published var getAllScheduleList: Bool = false
    @Published var isFirstFetch: Bool = true
    
    // MARK: - Initializer
    
    init(scheduleService: ScheduleAPIServiceProtocol,
         toDoService: ToDoListAPIServiceProtocol,
         userUptimeService: UserUptimeAPIServiceProtocol,
         prioritizationService: PrioritizationAPIServiceProtocol,
         mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource
    ) {
        self.toDoService = toDoService
        self.scheduleService = scheduleService
        self.userUptimeService = userUptimeService
        self.prioritizationService = prioritizationService
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        
        makeDummyEvent()
        updateSelectedDateOnScroll()
        
        preProcessingForAllEvents()
        
        TagManager.shared.fetchAndSaveTags { success in
            print(success ? "태그 동기화 완료" : "태그 동기화 실패")
        }
    }
    
    private func makeDummyEvent() {
        mEventDataSource.setCalendarData(mCallendarDataSource.wholeMonthDate)
    }
    
    // MARK: - Combine
    
    private var cancellable = Set<AnyCancellable>()
    
    // 주간 캘린더 스크롤할 때 현재 페이지에 맞춰 selectedDate를 업데이트하고 캘린더 이동
    private func updateSelectedDateOnScroll() {
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
    
    private func preProcessingForAllEvents() {
        Publishers.CombineLatest($getAllToDoList, $getAllScheduleList)
            .filter { $0 && $1 }
            .sink { [weak self] _ in
                guard let self else { return }
                if let date = self.selectedDate.date() {
                    self.updateTodayItems(for: date)
                }
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Drag And Drop
    
    @Published var dragTodayItem: TodayItem?
    @Published var dragTodoItem: ToDoItem?
    @Published var dropIndex: Int?
    
    //    func dropActionForToday(dragItem: TodayItemDataModel?, dropItem: TodayItemDataModel) {
    //        guard let dragItem,
    //              let dropIndex = todayItems.firstIndex(where: { $0.id == dropItem.id }),
    //              let fromIndex = todayItems.firstIndex(where: { $0.id == dragItem.id }),
    //              case .todo = dragItem else { return }
    //
    //        todayItems.move(fromOffsets: IndexSet(integer: fromIndex),
    //                        toOffset: dropIndex > fromIndex ? dropIndex + 1 : dropIndex)
    //    }
    //
    //    func dropActionForToDoList(dragItem: ToDoItem?, dropItem: ToDoItem) {
    //        guard let dragItem,
    //              let dropIndex = toDoListDict.firstIndex(where: { $0.id == dropItem.id }),
    //              let fromIndex = toDoListDict.firstIndex(where: { $0.id == dragItem.id }) else { return }
    //
    //        toDoListItems.move(fromOffsets: IndexSet(integer: fromIndex),
    //                           toOffset: dropIndex > fromIndex ? dropIndex + 1 : dropIndex)
    //    }
}

// MARK: - Today(ToDo + Schedule) Items Handling

extension WeeklyCalendarViewModel {
    // 일정이 하루라도 겹치는 스케줄, 투두를 가져와 투데이에 업데이트
    func updateTodayItems(for date: Date) {
        let dayStart = date.startOfDay
        let dayEnd = date.endOfDay
        
        var updatedItems: [TodayItem] = []
        
        for schedule in scheduleItems {
            guard let start = dateFromScheduleString(schedule.startDate),
                  let end   = dateFromScheduleString(schedule.endDate),
                  start <= dayEnd, end >= dayStart else { continue }
            updatedItems.append(.schedule(schedule))
        }
        
        for todo in toDoItems {
            guard let start = Date.dateFromString(todo.startDate, format: "yyyy-MM-dd"),
                  let end   = Date.dateFromString(todo.endDate, format: "yyyy-MM-dd"),
                  start <= dayEnd, end >= dayStart else { continue }
            updatedItems.append(.todo(todo))
        }
        
        let diff = updatedItems.difference(from: todayItems)
        if !diff.isEmpty {
            withAnimation(.easeInOut(duration: 0.1)) {
                todayItems = updatedItems
            }
        }
    }
    
    private func dateFromScheduleString(_ date: String) -> Date? {
        return Date.dateFromString(date, format: "yyyy-MM-dd'T'HH:mm:ss.SSS") ?? Date.dateFromString(date, format: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    private func mapAllDayItemsByDate() {
        allDayDict.removeAll()
        
        for dateModel in mCallendarDataSource.wholeMonthDate {
            guard let currentDate = dateModel.date() else { continue }
            let dayStart = currentDate.startOfDay
            let dayEnd = currentDate.endOfDay
            
            allDayDict[dateModel] = allDayItems.filter { allDayItem in
                guard let start = dateFromScheduleString(allDayItem.startDate),
                      let end = dateFromScheduleString(allDayItem.endDate) else { return false }
                return start <= dayEnd && end >= dayStart
            }
        }
    }
}

// MARK: - ToDo Items Handling

extension WeeklyCalendarViewModel {
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
    
    private func mapToDoDictByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for date in mCallendarDataSource.wholeMonthDate {
            toDoListDict[date] = toDoItems.filter {
                dateFormatter.date(from: $0.startDate)! == date.date()!
            }
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
        
        ToDoCache.shared.set(key: "todos", data: self.toDoItems)
    }
}

// MARK: - API

extension WeeklyCalendarViewModel {
    
    func getAllEvents(useCache: Bool = true) {
        getSchedulesTotal(useCache: useCache)
        getToDoListTotal(useCache: useCache)
    }
    
    func getSchedulesAllDay() {
        scheduleService.getSchedulesAllDay { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let allDayResponse = response?.data.allDaySchedulesList,
               !allDayResponse.isEmpty {
                
                DispatchQueue.main.async {
                    self.allDayItems = allDayResponse.map { AllDayItem(from: $0) }
                    self.mapAllDayItemsByDate()
                }
            }
        }
    }
    
    func getSchedulesTotal(useCache: Bool = true) {
        let start = Date()
        
        // 최초 실행이면 캐시 무시
        if !isFirstFetch, useCache, let cached = ScheduleCache.shared.get(key: "schedules") {
            DispatchQueue.main.async {
                self.scheduleItems = cached
                self.getAllScheduleList = true
                if let date = self.selectedDate.date() {
                    self.updateTodayItems(for: date)
                }
            }
            
            APICacheLogger.shared.logCacheCall(start: start, apiName: "Schedule")
            
            return
        }
        
        // 서버 호출
        scheduleService.getSchedulesTotal { [weak self] result in
            guard let self else { return }
            
            if case let .success(response) = result,
               let scheduleResponse = response?.data.scheduleWithOrderInfos {
                
                let mapped = scheduleResponse.map { ScheduleItem(from: $0) }
                DispatchQueue.main.async {
                    self.scheduleItems = mapped
                    self.getAllScheduleList = true
                    ScheduleCache.shared.set(key: "schedules", data: mapped)
                    self.isFirstFetch = false
                    if let date = self.selectedDate.date() {
                        self.updateTodayItems(for: date)
                    }
                }
            }
            
            APICacheLogger.shared.logServerCall(start: start, apiName: "Schedule")
        }
    }
    
    func deleteSchedule(scheduleId: Int) {
        scheduleService.deleteSchedule(scheduleId: scheduleId) { [weak self] result in
            guard let self = self else { return }
            
            if case .success = result {
                DispatchQueue.main.async {
                    self.todayItems.removeAll { if case .schedule(let s) = $0 { return s.id == scheduleId } else { return false } }
                    self.scheduleItems.removeAll { $0.id == scheduleId }
                    
                    if let date = self.selectedDate.date() {
                        self.updateTodayItems(for: date)
                    }
                }
            }
        }
    }
    
    func getToDoListTotal(useCache: Bool = true) {
        let start = Date()
        
        // 최초 실행이면 캐시 무시
        if !isFirstFetch, useCache, let cached = ToDoCache.shared.get(key: "todos") {
            DispatchQueue.main.async {
                self.toDoItems = cached
                self.mapToDoDictByDate()
                self.getAllToDoList = true
                if let date = self.selectedDate.date() {
                    self.updateTodayItems(for: date)
                }
            }
            
            APICacheLogger.shared.logCacheCall(start: start, apiName: "ToDo")
            
            return
        }
        
        // 서버 호출
        toDoService.getToDoListTotal { [weak self] result in
            guard let self else { return }
            
            if case let .success(response) = result,
               let toDoResponse = response?.data.toDoGetResponses {
                
                let mapped = toDoResponse.map { ToDoItem(from: $0) }
                DispatchQueue.main.async {
                    self.toDoItems = mapped
                    self.mapToDoDictByDate()
                    self.getAllToDoList = true
                    ToDoCache.shared.set(key: "todos", data: mapped)
                    self.isFirstFetch = false
                    if let date = self.selectedDate.date() {
                        self.updateTodayItems(for: date)
                    }
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
                    self.todayItems.removeAll { if case .todo(let t) = $0 { return t.id == toDoId } else { return false } }
                    self.toDoItems.removeAll { $0.id == toDoId }
                    
                    for (key, value) in self.toDoListDict {
                        self.toDoListDict[key] = value.filter { $0.id != toDoId }
                        if self.toDoListDict[key]?.isEmpty == true {
                            self.toDoListDict.removeValue(forKey: key)
                        }
                    }
                    
                    if let date = self.selectedDate.date() {
                        self.updateTodayItems(for: date)
                    }
                }
            }
        }
    }
    
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
