//
//  TodayWeeklyCalendarViewModel.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import Combine
import SwiftUI

import MDSKit
import MCalendar

final class TodayWeeklyCalendarViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let scheduleService: ScheduleAPIServiceProtocol
    private var toDoService: ToDoListAPIServiceProtocol
    private let userUptimeService: UserUptimeAPIServiceProtocol
    
    // MARK: - Published Properties
    
    @Published var mCallendarDataSource: MCalendarDataSource
    @Published var mEventDataSource: MEventDatasource
    
    @Published var todayItems: [TodayItem] = []
    @Published var scheduleItems: [ScheduleItem] = []
    @Published var allDayItems: [AllDayItem] = []
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
    
    @Published var getAllToDoList: Bool = false
    @Published var getAllScheduleList: Bool = false
    
    // MARK: - Initializer
    
    init(scheduleService: ScheduleAPIServiceProtocol,
         toDoService: ToDoListAPIServiceProtocol,
         userUptimeService: UserUptimeAPIServiceProtocol,
         mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource
    ) {
        self.toDoService = toDoService
        self.scheduleService = scheduleService
        self.userUptimeService = userUptimeService
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        
        makeDummyEvent()
        updateSelectedDateOnScroll()

        setSendNotificationObserver()
        preProcessingForAllEvents()
    }
    
    deinit {
        removeObserver()
    }
    
    func makeDummyEvent() {
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
                let index = Int(offset.x / UIScreen.main.bounds.width)
                self.selectedDate = self.mEventDataSource.eventList[index].dateModel
                if let date = self.mEventDataSource.eventList[index].dateModel.date() {
                    self.mCallendarDataSource.moveOtherWeekday(targetDate: date)
                }
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Today Items Handling
    
    // 일정이 하루라도 겹치는 스케줄, 투두를 가져와 투데이에 업데이트
    func updateTodayItems(for date: Date) {
        todayItems = []
        
        let dayStart = date.startOfDay
        let dayEnd = date.endOfDay
        
        let scheduleItem = scheduleItems.filter { scheduleItem in
            guard
                let start = dateFromScheduleString(scheduleItem.startDate),
                let end   = dateFromScheduleString(scheduleItem.endDate)
            else {
                return false
            }
            
            return start <= dayEnd && end >= dayStart
        }
            .map { TodayItem.schedule($0) }
        
        let toDoItem = toDoItems.filter { toDoItem in
            guard
                let start = Date.dateFromString(toDoItem.startDate, format: "yyyy-MM-dd"),
                let end   = Date.dateFromString(toDoItem.endDate, format: "yyyy-MM-dd")
            else {
                return false
            }
            
            return start <= dayEnd && end >= dayStart
        }
            .map { TodayItem.todo($0) }
        
        todayItems.append(contentsOf: scheduleItem)
        todayItems.append(contentsOf: toDoItem)
    }
    
    private func dateFromScheduleString(_ date: String) -> Date? {
        return Date.dateFromString(date, format: "yyyy-MM-dd'T'HH:mm:ss.SSS") ?? Date.dateFromString(date, format: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    // MARK: - View Helpers
    
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

extension TodayWeeklyCalendarViewModel {
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


// TODO: - 질문

extension TodayWeeklyCalendarViewModel {
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
}
