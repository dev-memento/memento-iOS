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
        loadDummyData()
    }
    
    @Published var allDayItems: [AllDayListDataModel] = [
//        .init(colorType: "mementoRed", allDayTitle: "김가현 땅스부대찌개에서 부대찌개 사오고 자기가 하나부터 열까지 다 끌ㅎ인척하던데 진짜 양심이 있는거냐 미친거야 미친거냐 미친거임?미친걸까 미친 ㅋㅋ "),
//        .init(colorType: "mementoOrange", allDayTitle: "지금은수요일새벽5시반"),
//        .init(colorType: "mementoLightGreen", allDayTitle: "마라샹궈먹었능데마싯다.."),
//        .init(colorType: "mementoOrange", allDayTitle: "오늘커피6샷마심레전드"),
//        .init(colorType: "mementoMint", allDayTitle: "보라매공원보라매공원보라매공원")
    ]
    
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
                    if let scheduleData = response?.data as? [ScheduleTotalResponseData] {
                        // TODO: - Tag API 연결 후 주석 해제
                        // self?.schedules = scheduleData
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
                    if let scheduleData = response?.data as? [ScheduleAllDayResponseData] {
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
}

extension WeeklyCalendarViewModel {
    // TODO: - Tag API 연결 후 더미 메소드 삭제
    func loadDummyData() {
        let dummyData: [ScheduleTotalResponseDataTest] = [
            ScheduleTotalResponseDataTest(id: 20, description: "나는김가현이다", startDate: "2025-01-12T20:35:00.657", endDate: "2025-01-13T23:35:00.657", timeDuration: "12PM-4PM (4h)",isAllDay: false, scheduleType: "NORMAL", order: 1, tagName: "SOPT", tagColorCode: "EE8AAD"),
            ScheduleTotalResponseDataTest(id: 19, description: "소금빵고마워", startDate: "2025-01-12T20:35:00.657", endDate: "2025-01-14T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 1, tagName: "SOPT", tagColorCode: "FFE483"),
            ScheduleTotalResponseDataTest(id: 11, description: "팀 프로젝트11111219", startDate: "2025-01-12T02:20:00", endDate: "2025-01-15T12:00:00", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 1, tagName: "SOPT", tagColorCode: "149C95"),
            ScheduleTotalResponseDataTest(id: 12, description: "팀 프로젝트11111219", startDate: "2025-01-13T02:20:00", endDate: "2025-01-18T12:00:00", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "APPLE", order: 2, tagName: "SOPT", tagColorCode: "FFE483"),
            ScheduleTotalResponseDataTest(id: 13, description: "지금 이건 서버 테스트", startDate: "2025-01-13T02:20:00", endDate: "2025-01-18T12:00:00", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 3, tagName: "SOPT", tagColorCode: "EE8AAD"),
            ScheduleTotalResponseDataTest(id: 14, description: "나는김가현", startDate: "2025-01-14T19:35:00.657", endDate: "2025-01-22T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 16, tagName: "SOPT", tagColorCode: "FFE483"),
            ScheduleTotalResponseDataTest(id: 15, description: "그만하자내힘들다", startDate: "2025-01-14T19:35:00.657", endDate: "2025-01-24T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 4, tagName: "SOPT", tagColorCode: "EE8AAD"),
            ScheduleTotalResponseDataTest(id: 16, description: "신민규이민규바보", startDate: "2025-01-15T19:35:00.657", endDate: "2025-01-24T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "GOOGLE", order: 5, tagName: "SOPT", tagColorCode: "149C95"),
            ScheduleTotalResponseDataTest(id: 17, description: "저데모데이안갈래요미안해요", startDate: "2025-01-23T19:35:00.657", endDate: "2025-01-26T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "APPLE", order: 6, tagName: "SOPT", tagColorCode: "FFE483"),
            ScheduleTotalResponseDataTest(id: 18, description: "걍더미데이터넣자", startDate: "2025-01-23T20:35:00.657", endDate: "2025-01-27T23:35:00.657", timeDuration: "12PM-4PM (4h)", isAllDay: false, scheduleType: "NORMAL", order: 7, tagName: "SOPT", tagColorCode: "149C95")
        ]
        self.schedules = dummyData
    }
    
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
