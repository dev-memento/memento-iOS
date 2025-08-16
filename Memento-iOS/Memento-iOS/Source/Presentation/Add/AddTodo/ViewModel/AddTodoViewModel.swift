//
//  AddTodoViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import SwiftUI

import MDSKit

final class AddTodoViewModel: ObservableObject, TagSelectable {
    
    // MARK: - Properties
    
    @Published var isButtonSelected: Bool = false
    
    @Published var description: String = ""
    
    @Published var showStartDatePicker: Bool = false
    @Published var showEndDatePicker: Bool = false
    @Published var showTagPicker: Bool = false
    @Published var showPriorityPicker: Bool = false
    
    @Published var isNaturalLanguageInputEnabled: Bool = false
    
    @Published var startDate: Date = Date() {
        didSet { updateFormattedDate() }
    }
    
    @Published var endDate: Date = Date() {
        didSet { updateFormattedDate() }
    }
    
    @Published var formattedStartDate: String = StringLiteral.AddTodo.today
    @Published var formattedEndDate: String = StringLiteral.AddTodo.today
    
    private let tagService: TagAPIServiceProtocol
    @Published var tags: [Tag] = []
    
    @Published var selectedTag: Tag = Tag(tagId: 1, color: .gray05, title: "Untitled") {
        didSet {
            tagId = selectedTag.tagId
        }
    }
    @Published var tagId: Int = 1
    
    @Published var priorityUrgency: Double = 0.0
    @Published var priorityImportance: Double = 0.0
    @Published var selectedPriority: Priority = .none {
        didSet {
            let (urgency, importance) = selectedPriority.getPriorityValues()
            priorityUrgency = urgency
            priorityImportance = importance
        }
    }
    
    var isTextEmpty: Bool {
        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let todoAPIService: TodoAPIServiceProtocol
    
    // MARK: - Initializer
    
    init(todoAPIService: TodoAPIServiceProtocol = TodoAPIService(),
         tagService: TagAPIServiceProtocol = TagAPIService()) {
        self.todoAPIService = todoAPIService
        self.tagService = tagService
        updateFormattedDate()
        getTagsAPI()
    }
    
    // MARK: - Helpers
    
    func getTagsAPI() {
        tagService.getTags { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(baseDTO) = result,
               let tagList = baseDTO?.data {
                
                self.tags = tagList.map { tag in
                    Tag(
                        tagId: tag.id,
                        color: Color(hex: tag.colorCode),
                        title: tag.name
                    )
                }
                
                if let firstTag = self.tags.first {
                    self.selectedTag = firstTag
                    self.tagId = firstTag.tagId
                }
                
            } else {
                print("태그 불러오기 실패")
            }
        }
    }
    
    func createTodo(completion: @escaping () -> Void) {
        let formattedStartDate = startDate.formattedDate(with: "yyyy-MM-dd")
        let formattedEndDate = endDate.formattedDate(with: "yyyy-MM-dd")
        
        todoAPIService.createTodo(
            startDate: formattedStartDate,
            description: description,
            endDate: formattedEndDate,
            tagId: selectedTag.tagId,
            priorityUrgency: priorityUrgency,
            priorityImportance: priorityImportance
        ) { result in
            switch result {
            case .success:
                completion()
                print("DEBUG: Success - 투두 생성 성공")
            case .badRequest, .notFound:
                completion()
                print("DEBUG: Error - 잘못된 요청입니다.")
            case .unAuthorized:
                completion()
                print("DEBUG: Error - 유효하지 않은 토큰입니다.")
            case .serverError:
                completion()
                print("DEBUG: Error - 내부 서버 에러")
            default:
                completion()
                print("DEBUG: Error - 에러 발생")
            }
        }
    }
    
    func limitTextLength(_ newText: String) {
        let lines = newText.split(whereSeparator: \.isNewline)
        
        if let lastLine = lines.last, lastLine.count > 30 {
            let truncated = String(lastLine.prefix(30))
            description = lines.dropLast()
                .map(String.init)
                .joined(separator: "\n") + "\n" + truncated + "\n"
        } else {
            description = newText
        }
    }
    
    func getPriorityImage(_ priority: Priority) -> MDSImageName {
        switch priority {
        case .immediate: return .matrix_immediate
        case .high: return .matrix_high
        case .medium: return .matrix_medium
        case .low: return .matrix_low
        case .none: return .matrix_none
        }
    }
    
    func postMakeScheduleNotiFication() {
        NotificationCenter.default.post(
            name: NSNotification.Name("postScheduleComplete"),
            object: nil
        )
    }
    
    private func updateFormattedDate() {
        formattedStartDate = formattedStartDate(for: startDate)
        formattedEndDate = formattedEndDate(for: endDate)
    }
    
    private func formattedStartDate(for date: Date) -> String {
        return Calendar.current.isDateInToday(date) ? StringLiteral.AddTodo.today : date.formattedDate(with: "MMM d, yyyy")
    }
    
    private func formattedEndDate(for date: Date) -> String {
        return Calendar.current.isDateInToday(date) ? StringLiteral.AddTodo.today : date.formattedDate(with: "MMM d")
    }
    
    private func getPriorityValues() -> (Double, Double) {
        return selectedPriority.getPriorityValues()
    }
}
