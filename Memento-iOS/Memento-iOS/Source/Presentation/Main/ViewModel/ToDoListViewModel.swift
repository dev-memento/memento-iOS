//
//  ToDoListViewModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/23/25.
//

import Combine
import SwiftUI

import MDSKit
import MCalendar

final class ToDoListViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private var toDoService: ToDoListAPIServiceProtocol
    
    // MARK: - Published Properties
    
    @Published var mCallendarDataSource: MCalendarDataSource
    @Published var mEventDataSource: MEventDatasource
    
    @Published var toDoList: [ToDoItem] = []
    @Published var toDoListDict: [MCalendarDataModel: [ToDoItem]] = [:]
    
    @Published var currentOffset: CGPoint = .zero
    @Published var selectedDate: MCalendarDataModel = .init(year: "2025",
                                                            month: "1",
                                                            day: "10",
                                                            weekday: .fri)
    
    // MARK: - Initializer
    
    init(toDoService: ToDoListAPIServiceProtocol,
         mCallendarDataSource: MCalendarDataSource,
         mEventDataSource: MEventDatasource,
    ) {
        self.toDoService = toDoService
        self.mCallendarDataSource = mCallendarDataSource
        self.mEventDataSource = mEventDataSource
    }
    
    // MARK: - toDoListDict Helpers
    
    private func mapToDoDictByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for date in mCallendarDataSource.wholeMonthDate {
            toDoListDict[date] = toDoList.filter {
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
}

// MARK: - API

extension ToDoListViewModel {
    func getToDoListTotal() {
        toDoService.getToDoListTotal { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let toDoList = response?.data.toDoGetResponses, !toDoList.isEmpty {
                
                DispatchQueue.main.async {
                    self.toDoList = toDoList.map { ToDoItem(from: $0) }
                    self.mapToDoDictByDate()
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
    
    func updateToDoCompletion(toDoId: Int) {
        toDoService.updateToDoCompletion(toDoId: toDoId) { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               response?.data != nil {
                
                DispatchQueue.main.async {
                    if let index = self.toDoList.firstIndex(where: { $0.id == toDoId }) {
                        self.toDoList[index].isCompleted.toggle()
                    }
                    self.getToDoListTotal()
                }
            }
        }
    }
}
