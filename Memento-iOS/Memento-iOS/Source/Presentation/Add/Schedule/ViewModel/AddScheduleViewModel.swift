//
//  AddScheduleViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

final class AddScheduleViewModel: ObservableObject, TagSelectable {
    
    // MARK: - Dependencies
    
    private var scheduleService: ScheduleAPIServiceProtocol
    
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
    
    @Published var startDate: Date = Date().startOfDay {
        didSet { autoToggleAllDay() }
    }
    @Published var endDate: Date = Date().startOfDay {
        didSet { autoToggleAllDay() }
    }
    @Published var startTime: Date = Date().roundedToNearestHalfHour() {
        didSet { autoToggleAllDay() }
    }
    @Published var endTime: Date = Calendar.current.date(byAdding: .hour, value: 2, to: Date().roundedToNearestHalfHour()) ?? Date().roundedToNearestHalfHour() {
        didSet { autoToggleAllDay() }
    }
    
    @Published var isAllDay: Bool = false {
        didSet {
            if isUpdatingAllDay { return }
            
            if isAllDay {
                // All-Day 활성화 시 start/end Time을 startDate/endDate로 맞춤
                startTime = startDate.startOfDay
                endTime = endDate.startOfDay
            } else {
                isUpdatingAllDay = true
                startDate = Date().startOfDay
                endDate = Date().startOfDay
                startTime = Date().roundedToNearestHalfHour()
                endTime = Calendar.current.date(byAdding: .hour, value: 2, to: Date().roundedToNearestHalfHour()) ?? Date().roundedToNearestHalfHour()
                isUpdatingAllDay = false
            }
        }
    }
    
    @Published var tagList: [Tag] = []
    @Published var selectedTag: Tag
    
    // MARK: - Initializer
    
    init(scheduleService: ScheduleAPIServiceProtocol = ScheduleAPIService()) {
        
        self.scheduleService = scheduleService
        
        if let untitledTag = TagManager.shared.getTag(by: "Untitled") {
            self.selectedTag = Tag(tagId: untitledTag.id, name: untitledTag.name, color: Color(hex: untitledTag.colorCode))
        } else {
            self.selectedTag = Tag(tagId: 0, name: "Loading...", color: .gray05)
        }
    }
    
    // MARK: - Computed Properties
    
    var isTextEmpty: Bool { description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    
    var formattedStartDate: String { startDate.stringFromDate(with: "MMM d, yyyy") }
    var formattedEndDate: String { endDate.stringFromDate(with: "MMM d, yyyy") }
    
    var formattedStartTime: String { formatTime(startTime) }
    var formattedEndTime: String { formatTime(endTime) }
    
    var tagId: Int { selectedTag.tagId }
    
    private var parseWorkItem: DispatchWorkItem?
    
    // MARK: - Date Time Helpers
    
    private func debouncedParse() {
        parseWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.parseNaturalLanguage()
        }
        parseWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    func parseNaturalLanguage() {
        let result = NaturalLanguageDateParser.shared.parse(description, parseTime: true)
        
        if let s = result.startDate {
            startDate = Calendar.current.startOfDay(for: s)
            startTime = s
        }
        if let e = result.endDate {
            endDate = Calendar.current.startOfDay(for: e)
            endTime = e
        }
        
        if description != result.title {
            DispatchQueue.main.async { [weak self] in
                self?.description = result.title
            }
        }
    }
    
    // Request DTO에 맞게 날짜 시간 결합
    func formatDate(date: Date, time: Date) -> String {
        Date().combineDateAndTime(date: date, time: time).stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
    
    // isAllDay가 true 면 Time Picker에 All-Day 표시
    func formatTime(_ date: Date) -> String {
        isAllDay ? StringLiteral.AddSchedule.allDay : date.stringFromDate(with: "h:mm a")
    }
    
    // MARK: - All-Day Handling
    
    private var isUpdatingAllDay = false
    
    private func autoToggleAllDay() {
        if isUpdatingAllDay { return }
        
        let startDateTime = Date().combineDateAndTime(date: startDate, time: startTime)
        let endDateTime = Date().combineDateAndTime(date: endDate, time: endTime)
        let interval = endDateTime.timeIntervalSince(startDateTime)
        
        if interval >= .oneDay && !isAllDay {
            isAllDay = true
        }
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
    
    func postSchedule(completion: @escaping () -> Void) {
        let body = SchedulePostRequest(
            description: description,
            startDate: formatDate(date: startDate, time: startTime),
            endDate: formatDate(date: endDate, time: endTime),
            isAllDay: isAllDay,
            tagId: selectedTag.tagId
        )
        
        scheduleService.postSchedule(body: body) { _ in
            NotificationCenter.default.post(
                name: Notification.Name("refreshSchedule"),
                object: nil
            )
            
            completion()
        }
    }
}
