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
    
    @Published var schedules: [ScheduleTotalResponseDataTest] = []
    @Published var tag: [TagResponseData] = []
    @Published var toDoList: [ToDoListTotalResponseDataTest] = []
    @Published var allday: [ScheduleAllDayResponseDataTest] = []
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
    }
    
    deinit {
        removeObserver()
    }
    
    @Published var todayItems: [TodayItemDataModel] = []
    
    @Published var toDoListItems: [ToDoListDataModel] = []
    
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
    
    
    private let dateFormatter = DateFormatter()
    @Published var toDoListItemDict: [MCalendarDataModel: [ToDoListDataModel]] = [:]
    
    func preprocessingForEventDate() {
        for date in mCallendarDataSource.wholeMonthDate {
            toDoListItemDict[date] = filteredTargetEvent(date)
        }
    }
    
    private func filteredTargetEvent(_ date: MCalendarDataModel) -> [ToDoListDataModel] {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return toDoListItems.filter {
            dateFormatter.date(from: $0.date)! == date.date()!
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
        self.getSchedulesTotalAPI()
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

extension WeeklyCalendarViewModel {
    func getSchedulesTotalAPI() {
        scheduleService.getSchedulesTotal { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let scheduleData = response?.data.scheduleWithOrderInfos {
                        self?.schedules = scheduleData
                    } else {
                        print("데이터변환 실패")
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
    
    func getToDoListTotalAPI() {
        toDoListService.getToDoList { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let toDoData = response?.data.toDoGetResponses {
                        self?.toDoList = toDoData
                        self?.toDoListItems = toDoData.map { item in
                            ToDoListDataModel(
                                id: item.id,
                                colorType: item.tagColor,
                                toDoTitle: item.description,
                                date: item.startDate,
                                dueDate: item.endDate,
                                priorityType: Priority(rawValue: item.priorityType) ?? .low,
                                isChecked: item.isCompleted
                            )
                        }
                    } else {
                        print("데이터변환 실패")
                        self?.toDoListItems = []
                    }
                    self?.preprocessingForEventDate()
                }
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
    
    func userUptimeAPI() {
        userUptimeService.fetchUptime{ result in
            switch result {
            case .success(let response):
                print("시간 가져오기 성공")
                // 추가 작업 필요 시 여기에 작성
                if let wakeUpTime = response?.data.wakeUpTime, let windDownTime = response?.data.windDownTime {
                    self.wakeUpTime = wakeUpTime
                    self.windDownTime = wakeUpTime
                    print("시간 가져오기 성공 \(self.wakeUpTime) \(self.windDownTime)")
                } else {
                    self.wakeUpTime = "8 AM"
                    self.windDownTime = "11 PM"
                }
            default:
                print("시간 가져오기 실패")
            }
        }
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
        // 1) "하루의 시작"과 "하루의 끝" 구하기
        let dayStart = date.startOfDay
        let dayEnd = date.endOfDay
        
        // 2) schedules 배열에서 일정이 하루라도 겹치는 것만 필터링
        todayItems = schedules.filter { schedule in
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
