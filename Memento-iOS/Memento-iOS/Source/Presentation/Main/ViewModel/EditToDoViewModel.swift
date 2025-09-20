//
//  EditToDoViewModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 9/6/25.
//

import Foundation
import SwiftUI
import Combine
import MDSKit

final class EditToDoViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let toDoService: ToDoListAPIServiceProtocol
    
    private let toDoId: Int
    
    // MARK: - Published Properties
    
    @Published var description: String
    
    @Published var startDate: String {
        didSet { validateDates(updatedBy: .start) }
    }
    
    @Published var endDate: String {
        didSet { validateDates(updatedBy: .end) }
    }
    
    @Published var tagName: String
    @Published var tagColor: String
    @Published var tagList: [Tag] = []
    
    @Published var priorityType: Priority
    
    init(
        toDoItem: ToDoItem,
        toDoService: ToDoListAPIServiceProtocol = ToDoListAPIService()
    ) {
        self.startDate = toDoItem.startDate
        self.endDate = toDoItem.endDate
        self.description = toDoItem.description
        self.tagName = toDoItem.tagName
        self.tagColor = toDoItem.tagColor
        self.priorityType = toDoItem.priorityType
        self.toDoId = toDoItem.id
        
        self.toDoService = toDoService
        
        getTags()
    }
    
    // MARK: - Date Handling
    
    private func validateDates(updatedBy type: DateTimeType) {
        guard let start = Date.dateFromString(startDate, format: "yyyy-MM-dd"),
              let end = Date.dateFromString(endDate, format: "yyyy-MM-dd") else { return }
        
        if start > end {
            switch type {
            case .start:
                endDate = start.stringFromDate(with: "yyyy-MM-dd")
            case .end:
                startDate = end.stringFromDate(with: "yyyy-MM-dd")
            }
        }
    }
    
    // MARK: - API
    
    func getTags() {
        guard TagManager.shared.hasLocalTags() else {
            return
        }
        
        let localTags = TagManager.shared.getSavedTags()
        
        let tags = localTags.map { Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) }
        self.tagList = tags
        
        if let selected = tags.first(where: { $0.name == self.tagName }) ?? tags.first {
            self.tagName = selected.name
            self.tagColor = selected.color.toHex()
        }
    }
    
    func updateToDo(completion: @escaping () -> Void) {
        let tagId = tagList.first(where: { $0.name == tagName })?.tagId ?? tagList.first?.tagId ?? 1
        
        let body = ToDoPostRequest(
            startDate: startDate,
            description: description,
            endDate: endDate,
            tagId: tagId,
            priorityUrgency: priorityType == .none ? nil : priorityType.getPriorityValues().urgency,
            priorityImportance: priorityType == .none ? nil : priorityType.getPriorityValues().importance
        )
        
        toDoService.updateToDo(toDoId: toDoId, body: body) { _ in
            NotificationCenter.default.post(
                name: Notification.Name("refreshToDoList"),
                object: nil
            )
            
            completion()
        }
    }
}
