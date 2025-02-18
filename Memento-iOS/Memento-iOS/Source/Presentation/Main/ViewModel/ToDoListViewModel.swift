//
//  ToDoListViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 2/16/25.
//

import Foundation
import Combine
import MCalendar

final class ToDoListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var toDoListItems: [ToDoListDataModel] = []
    @Published var toDoListItemDict: [MCalendarDataModel: [ToDoListDataModel]] = [:]
    @Published var showTodoAlert = false
    @Published var selectedItem: ToDoListDataModel?
    @Published var selectedDate: MCalendarDataModel
    @Published var scrollTarget: MCalendarDataModel?
    
    // MARK: - Properties
    let mCallendarDataSource: MCalendarDataSource
    
    // MARK: - Dependencies
    private let toDoListService: ToDoListAPIServiceProtocol
    private let dateFormatter = DateFormatter()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(toDoListService: ToDoListAPIServiceProtocol, calendarDataSource: MCalendarDataSource) {
        self.toDoListService = toDoListService
        self.mCallendarDataSource = calendarDataSource
        self.dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 초기 선택 날짜 설정
        self.selectedDate = .init(
            year: "2025",
            month: "1",
            day: "10",
            weekday: .fri
        )
    }
    
    // MARK: - Calendar Related Methods
    var wholeMonthDate: [MCalendarDataModel] {
        return mCallendarDataSource.wholeMonthDate
    }
    
    func onDateSelected(_ date: MCalendarDataModel) {
        selectedDate = date
        makeScrollTarget()
    }
    
    func makeScrollTarget() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollTarget = self.selectedDate
        }
    }
    
    func moveToToday() {
        let date = Date()
        mCallendarDataSource.moveOtherWeekday(targetDate: date)
        if let targetDateModel = date.makeTargetDate() {
            selectedDate = targetDateModel
        }
    }
    
    // MARK: - Date Formatting Methods
    func makeMonthDate(month: String) -> String {
        switch month {
        case "1": return "Jan"
        case "2": return "Feb"
        case "3": return "Mar"
        case "4": return "Apr"
        case "5": return "May"
        case "6": return "Jun"
        case "7": return "Jul"
        case "8": return "Aug"
        case "9": return "Sep"
        case "10": return "Oct"
        case "11": return "Nov"
        case "12": return "Dec"
        default: return ""
        }
    }
    
    func isTopPriorityItem(at item: ToDoListDataModel, items: [ToDoListDataModel]) -> Bool {
        guard !item.isChecked else { return false }
        let uncheckedItems = items.filter { !$0.isChecked }
        return uncheckedItems.first == item
    }
    
    func preprocessingForEventDate() {
        for date in wholeMonthDate {
            toDoListItemDict[date] = filteredTargetEvent(date)
        }
    }
    
    private func filteredTargetEvent(_ date: MCalendarDataModel) -> [ToDoListDataModel] {
        return toDoListItems.filter {
            dateFormatter.date(from: $0.date)! == date.date()!
        }
    }
    
    func getToDoListTotalAPI() {
        toDoListService.getToDoList { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let toDoData = response?.data.toDoGetResponses {
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
                        self?.preprocessingForEventDate()
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
    
    func updateToDoCompletion(toDoId: Int, date: MCalendarDataModel) {
        toDoListService.updateToDoCompletion(toDoId: toDoId) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response?.data != nil {
                        if let index = self?.toDoListItemDict[date]?.firstIndex(where: { $0.id == toDoId }) {
                            self?.toDoListItemDict[date]?[index].isChecked.toggle()
                        }
                    }
                }
            default:
                print("ERROR")
            }
        }
    }
    
    func deleteTodoItem(at date: MCalendarDataModel, todoId: Int) {
        if let index = toDoListItemDict[date]?.firstIndex(where: { $0.id == todoId }) {
            toDoListItemDict[date]?.remove(at: index)
            
            if toDoListItemDict[date]?.isEmpty == true {
                toDoListItemDict.removeValue(forKey: date)
            }
        }
    }
}
