//
//  AddToDoViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import SwiftUI

import MDSKit

final class AddToDoViewModel: ObservableObject, TagSelectable {
    
    // MARK: - Dependencies
    
    private var toDoService: ToDoListAPIServiceProtocol
    private let tagService: TagAPIServiceProtocol
    
    // MARK: - User Input
    
    @Published var isNaturalLanguageEnabled: Bool = false
    @Published var description: String = ""
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var tagList: [Tag] = []
    @Published var selectedTag: Tag = Tag(tagId: 1, name: "Untitled", color: .gray05)

    @Published var priorityUrgency: Double = 0.0
    @Published var priorityImportance: Double = 0.0
    @Published var selectedPriority: Priority = .none {
        didSet { updatePriorityValue() }
    }
    
    // MARK: - Picker State
    
    @Published var isStartDatePickerPresented: Bool = false
    @Published var isEndDatePickerPresented: Bool = false
    @Published var isTagPickerPresented: Bool = false
    @Published var isPriorityPickerPresented: Bool = false
    
    // MARK: - Initializer
    
    init(toDoService: ToDoListAPIServiceProtocol = ToDoListAPIService(),
         tagService: TagAPIServiceProtocol = TagAPIService()) {
        
        self.toDoService = toDoService
        self.tagService = tagService
    }
    
    // MARK: - Computed Properties
    
    var isTextEmpty: Bool { description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    var formattedStartDate: String { formatDate(startDate) }
    var formattedEndDate: String { formatDate(endDate) }
    
    var tagId: Int { selectedTag.tagId }
    
    // MARK: - Date Helpers
    
    func formatDate(_ date: Date) -> String {
        Calendar.current.isDateInToday(date) ? StringLiteral.AddToDo.today : date.stringFromDate(with: "MMM d")
    }
    
    // MARK: - Priority Helpers
    
    private func updatePriorityValue() {
        priorityUrgency = selectedPriority.getPriorityValues().urgency
        priorityImportance = selectedPriority.getPriorityValues().importance
    }
    
    // MARK: - API
    
    func getTags() {
        tagService.getTags { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let tags = response?.data, !tags.isEmpty {
                
                self.tagList = tags.map { Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) }
                self.selectedTag = self.tagList.first ?? self.selectedTag
            }
        }
    }
    
    func postToDo(completion: @escaping () -> Void) {
        let body = ToDoPostRequest(
            startDate: startDate.stringFromDate(with: "yyyy-MM-dd"),
            description: description,
            endDate: endDate.stringFromDate(with: "yyyy-MM-dd"),
            tagId: selectedTag.tagId,
            priorityUrgency: priorityUrgency,
            priorityImportance: priorityImportance
        )
        
        toDoService.postToDo(body: body) { _ in
            NotificationCenter.default.post(
                name: Notification.Name("refreshToDoList"),
                object: nil
            )
            
            completion()
        }
    }
}
