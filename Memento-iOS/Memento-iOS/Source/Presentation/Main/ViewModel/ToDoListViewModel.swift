//
//  ToDoListViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 2/16/25.
//

import Combine
import SwiftUI

import MDSKit
import MCalendar

final class ToDoListViewModel: ObservableObject {
    @Published var toDoList: [ToDoListTotalResponseDataTest] = []
    private let tagService: TagAPIServiceProtocol
    private let toDoListService: ToDoListAPIServiceProtocol
    private let toDoService: TodoAPIServiceProtocol
    @Published var toDoListItems: [ToDoListDataModel] = []
    @Published var mCallendarDataSource: MCalendarDataSource
    @Published var mEventDataSource: MEventDatasource
    @Published var currentOffset: CGPoint = .zero
    @Published var selectedDate: MCalendarDataModel = .init(year: "2025",
                                                            month: "1",
                                                            day: "10",
                                                            weekday: .fri)
    private var cancellable = Set<AnyCancellable>()
    @Published var getAllTodoList: Bool = false
    private let dateFormatter = DateFormatter()
    @Published var toDoListItemDict: [MCalendarDataModel: [ToDoListDataModel]] = [:]
    
    
    init(
        tagService: TagAPIServiceProtocol,
        toDoListService: ToDoListAPIServiceProtocol,
        mCallendarDataSource: MCalendarDataSource,
        mEventDataSource: MEventDatasource,
        toDoService: TodoAPIServiceProtocol
    ) {
        self.tagService = tagService
        self.toDoListService = toDoListService
        self.mCallendarDataSource = mCallendarDataSource
        self.mEventDataSource = mEventDataSource
        self.toDoService = toDoService
    }
    
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
}

extension ToDoListViewModel {
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
    
    func deleteTodo(todoId: Int) {
        toDoService.deleteTodo(todoId: todoId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.removeTodoFromDict(todoId: todoId)
                default:
                    print("Todo 삭제 실패")
                }
            }
        }
    }
    
    private func removeTodoFromDict(todoId: Int) {
        guard let date = toDoListItemDict.first(where: { $0.value.contains(where: { $0.id == todoId }) })?.key,
              let index = toDoListItemDict[date]?.firstIndex(where: { $0.id == todoId }) else { return }
        
        toDoListItemDict[date]?.remove(at: index)
        if toDoListItemDict[date]?.isEmpty == true {
            toDoListItemDict.removeValue(forKey: date)
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
                                priorityType: Priority(rawValue: item.priorityType.lowercased()) ?? .none,
                                isChecked: item.isCompleted,
                                tagName: item.tagName
                            )
                        }
                        self?.getAllTodoList = true
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
    
    func updateToDoCompletion(toDoId: Int) {
        toDoListService.updateToDoCompletion(toDoId: toDoId) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response?.data != nil {
                        if let index = self?.toDoList.firstIndex(where: { $0.id == toDoId }) {
                            self?.toDoListItems[index].isChecked.toggle()
                        }
                        self?.getToDoListTotalAPI()
                    }
                }
            default:
                print("ERROR")
            }
        }
    }
    
}
