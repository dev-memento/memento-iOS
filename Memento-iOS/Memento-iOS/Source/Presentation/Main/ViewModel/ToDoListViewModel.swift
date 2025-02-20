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
    private var cachedToDoList: [ToDoListDataModel] = [] // 캐싱 데이터 저장
    private var isCacheValid: Bool = false // 캐시가 유효한지 체크
    
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
    
    private func filteredTargetEvent(_ date: MCalendarDataModel) -> [ToDoListDataModel] {
        return toDoListItems.filter {
            dateFormatter.date(from: $0.date)! == date.date()!
        }
    }
    
    // MARK: - API 호출 + 캐싱
    func getToDoListTotalAPI(forceRefresh: Bool = false) {
        if !forceRefresh, isCacheValid {
            print("[CACHE] 기존 데이터 사용")
            self.toDoListItems = cachedToDoList
            preprocessingForEventDate()  // ✅ 기존 캐시 데이터를 UI에 반영
            return
        }

        // ✅ 캐싱된 데이터 먼저 적용 (이전 UI 문제 해결)
        DispatchQueue.main.async {
            self.toDoListItems = self.cachedToDoList
            self.preprocessingForEventDate()
        }

        // ✅ API 호출을 비동기로 실행하여 UI 블로킹 방지
        DispatchQueue.global(qos: .userInitiated).async {
            self.toDoListService.getToDoList { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let response):
                    if let toDoData = response?.data.toDoGetResponses {
                        let mappedData = toDoData.map { item in
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

                        DispatchQueue.main.async {
                            self.toDoListItems = mappedData
                            self.cachedToDoList = mappedData
                            self.isCacheValid = true
                            self.preprocessingForEventDate()
                        }
                    }
                default:
                    print("[ERROR] 데이터 가져오기 실패")
                }
            }
        }
    }

    // MARK: - 날짜별 ToDo 그룹화
    private func preprocessingForEventDate() {
        DispatchQueue.global(qos: .userInitiated).async {
            // ✅ localToDoList에 데이터를 복사하여 Thread-Safe하게 처리
            let localToDoList = self.toDoListItems
            var groupedToDos: [MCalendarDataModel: [ToDoListDataModel]] = [:]
            let calendar = Calendar.current

            for todo in localToDoList {
                if let todoDate = self.dateFormatter.date(from: todo.date) {
                    let components = calendar.dateComponents([.year, .month, .day, .weekday], from: todoDate)
                    
                    if let year = components.year,
                       let month = components.month,
                       let day = components.day,
                       let weekday = components.weekday {
                        
                        let weekDayOption = self.convertToMWeekDayOptions(from: weekday)  // ✅ 변환 함수 사용
                        
                        let dateModel = MCalendarDataModel(
                            year: "\(year)",
                            month: "\(month)",
                            day: "\(day)",
                            weekday: weekDayOption
                        )
                        
                        groupedToDos[dateModel, default: []].append(todo)
                    }
                }
            }

            // ✅ UI 업데이트는 반드시 메인 스레드에서 실행
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.toDoListItemDict = groupedToDos  // ✅ 한 번에 딕셔너리 업데이트
                print("🚀 toDoListItemDict 업데이트됨: \(self.toDoListItemDict.count)개의 날짜 데이터")
            }
        }
    }

    
    /// ✅ `Calendar`의 `weekday` 값을 `MWeekDayOptions`으로 변환하는 함수
    private func convertToMWeekDayOptions(from weekday: Int) -> MWeekDayOptions {
        switch weekday {
        case 1: return .sun  // ✅ 일요일 (Calendar 기준 1 → MWeekDayOptions 기준 0)
        case 2: return .mon  // ✅ 월요일
        case 3: return .tue  // ✅ 화요일
        case 4: return .wed  // ✅ 수요일
        case 5: return .thu  // ✅ 목요일
        case 6: return .fri  // ✅ 금요일
        case 7: return .sat  // ✅ 토요일
        default: return .mon  // ✅ 기본값 (예외 처리)
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
