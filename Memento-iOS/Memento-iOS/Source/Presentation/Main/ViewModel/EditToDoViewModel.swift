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
    private let tagService: TagAPIServiceProtocol
    
    private let toDoId: Int
    
    // MARK: - User Input
    
    @Published var description: String
    
    @Published var startDate: String
    @Published var endDate: String
    
    @Published var tagName: String
    @Published var tagColor: String
    @Published var tagList: [Tag] = []
    
    @Published var priorityType: Priority
    
    init(
        toDoItem: ToDoItem,
        tagService: TagAPIServiceProtocol = TagAPIService(),
        toDoService: ToDoListAPIServiceProtocol = ToDoListAPIService()
    ) {
        self.startDate = toDoItem.startDate
        self.endDate = toDoItem.endDate
        self.description = toDoItem.description
        self.tagName = toDoItem.tagName
        self.tagColor = toDoItem.tagColor
        self.priorityType = toDoItem.priorityType
        self.toDoId = toDoItem.id
        self.tagService = tagService
        self.toDoService = toDoService
        
        getTags()
    }
    
    // MARK: - API
    
    func getTags() {
        tagService.getTags { [weak self] result in
            guard let self = self else { return }
            
            guard case let .success(response) = result,
                  let tags = response?.data.map({ Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) })
            else { return }
            
            self.tagList = tags
            
            if let selected = tags.first(where: { $0.name == self.tagName }) ?? tags.first {
                self.tagName = selected.name
                self.tagColor = selected.color.toHex()
            }
        }
    }
    
    func updateToDo(completion: @escaping () -> Void) {
        let tagId = tagList.first(where: { $0.name == tagName })?.tagId ?? tagList.first?.tagId ?? 1
        
        let body = ToDoPostRequest(
            startDate: startDate,
            description: description,
            endDate: endDate,
            tagId: tagId,
            priorityUrgency: priorityType.getPriorityValues().urgency,
            priorityImportance: priorityType.getPriorityValues().importance
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
