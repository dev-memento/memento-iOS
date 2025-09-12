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
    
    // MARK: - User Input
    
    @Published var isNaturalLanguageEnabled: Bool = false {
        didSet {
            if isNaturalLanguageEnabled {
                parseNaturalLanguage()
            }
        }
    }
    
    @Published var description: String = "" {
        didSet {
            if isNaturalLanguageEnabled {
                debouncedParse()
            }
        }
    }
    
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
    
    init(toDoService: ToDoListAPIServiceProtocol = ToDoListAPIService()) {
        
        self.toDoService = toDoService
    }
    
    // MARK: - Computed Properties
    
    var isTextEmpty: Bool { description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    var formattedStartDate: String { formatDate(startDate) }
    var formattedEndDate: String { formatDate(endDate) }
    
    var tagId: Int { selectedTag.tagId }
    
    private var parseWorkItem: DispatchWorkItem?
    
    // MARK: - Date Helpers
    
    func formatDate(_ date: Date) -> String {
        Calendar.current.isDateInToday(date) ? StringLiteral.AddToDo.today : date.stringFromDate(with: "MMM d")
    }
    
    private func debouncedParse() {
        parseWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.parseNaturalLanguage()
        }
        parseWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    func parseNaturalLanguage() {
        let result = NaturalLanguageDateParser.shared.parse(description)
        
        if let s = result.startDate { startDate = s }
        if let e = result.endDate { endDate = e }
        
        if description != result.title {
            DispatchQueue.main.async { [weak self] in
                self?.description = result.title
            }
        }
    }
    
    // MARK: - Priority Helpers
    
    private func updatePriorityValue() {
        priorityUrgency = selectedPriority.getPriorityValues().urgency
        priorityImportance = selectedPriority.getPriorityValues().importance
    }
    
    // MARK: - API
    
    func getTags() {
        guard TagManager.shared.hasLocalTags() else {
            return
        }
        
        let localTags = TagManager.shared.getSavedTags()
        
        self.tagList = localTags.map { Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) }
        self.selectedTag = self.tagList.first ?? self.selectedTag
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
