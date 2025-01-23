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
    
    @Published var schedules: [ScheduleTotalResponseData] = []
    @Published var tag: [TagResponseData] = []
    @Published var toDoList: [ToDoListTotalResponseData] = []
    private let scheduleService: ScheduleAPIServiceProtocol
    private let tagService: TagAPIServiceProtocol
    private let toDoListService: ToDoListAPIServiceProtocol
    
    init(mCalendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource,
         scheduleService: ScheduleAPIServiceProtocol,
         tagService: TagAPIServiceProtocol,
         toDoListService: ToDoListAPIServiceProtocol
    ) {
        
        self.mCallendarDataSource = mCalendarDataSource
        self.mEventDataSource = mEventDataSource
        self.scheduleService = scheduleService
        self.tagService = tagService
        self.toDoListService = toDoListService
        
        
        makeDummyEvent()
        addOffsetDebounce()
    }
    
    @Published var allDayItems: [AllDayListDataModel] = [
        .init(colorType: "mementoRed", allDayTitle: "김가현 땅스부대찌개에서 부대찌개 사오고 자기가 하나부터 열까지 다 끌ㅎ인척하던데 진짜 양심이 있는거냐 미친거야 미친거냐 미친거임?미친걸까 미친 ㅋㅋ "),
        .init(colorType: "mementoOrange", allDayTitle: "지금은수요일새벽5시반"),
        .init(colorType: "mementoLightGreen", allDayTitle: "마라샹궈먹었능데마싯다.."),
        .init(colorType: "mementoOrange", allDayTitle: "오늘커피6샷마심레전드"),
        .init(colorType: "mementoMint", allDayTitle: "보라매공원보라매공원보라매공원")
    ]
    
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
                    if let toDoData = response?.data as? [ToDoListTotalResponseData] {
                        self?.toDoList = toDoData
                    } else {
                        print("데이터변환 실패")
                        self?.toDoListItems = []
                    }
                }
            default:
                print("ERROR")
            }
        }
    }
    
}

