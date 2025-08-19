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
    private var scheduleAPIService: ScheduleAPIServiceProtocol
    private let tagAPIService: TagAPIServiceProtocol
    
    
    // MARK: - User Input
    @Published var isNaturalLanguageEnabled: Bool = false
    @Published var title: String = ""
    
    @Published var startDate: Date = Date().startOfDay {
        didSet { autoUpdateAllDayStatus() }
    }
    @Published var endDate: Date = Date().startOfDay {
        didSet { autoUpdateAllDayStatus() }
    }
    @Published var startTime: Date = Date().roundedToNearestHalfHour() {
        didSet { autoUpdateAllDayStatus() }
    }
    @Published var endTime: Date = Calendar.current.date(byAdding: .hour, value: 2, to: Date().roundedToNearestHalfHour()) ?? Date().roundedToNearestHalfHour() {
        didSet { autoUpdateAllDayStatus() }
    }
    
    @Published var isAllDay: Bool = false {
        didSet {
            updateTimeForAllDayStatus()
        }
    }
    
    @Published var tagList: [Tag] = []
    @Published var selectedTag: Tag = Tag(tagId: 1, name: "Untitled", color: .gray05) {
        didSet { tagId = selectedTag.tagId }
    }
    @Published var tagId: Int = 1
    
    
    // MARK: - Initializer
    init(scheduleApiService: ScheduleAPIService = ScheduleAPIService(),
         tagService: TagAPIServiceProtocol = TagAPIService()) {
        
        self.scheduleAPIService = scheduleApiService
        self.tagAPIService = tagService
    }
    
    
    // MARK: - Picker State
    @Published var isStartDatePickerPresented: Bool = false
    @Published var isEndDatePickerPresented: Bool = false
    @Published var isStartTimePickerPresented: Bool = false
    @Published var isEndTimePickerPresented: Bool = false
    @Published var isTagPickerPresented: Bool = false
    
    
    // MARK: - Picker Control
    func presentDatePicker(type: DateTimeType) {
        switch type {
        case .start: isStartDatePickerPresented = true
        case .end: isEndDatePickerPresented = true
        }
    }
    
    func dismissDatePicker(type: DateTimeType) {
        switch type {
        case .start: isStartDatePickerPresented = false
        case .end: isEndDatePickerPresented = false
        }
    }
    
    func presentTimePicker(type: DateTimeType) {
        guard !isAllDay else { return }
        switch type {
        case .start: isStartTimePickerPresented = true
        case .end: isEndTimePickerPresented = true
        }
    }
    
    func dismissTimePicker(type: DateTimeType) {
        switch type {
        case .start: isStartTimePickerPresented = false
        case .end: isEndTimePickerPresented = false
        }
    }
    
    func presentTagPicker() { isTagPickerPresented = true }
    func dismissTagPicker() { isTagPickerPresented = false }
    
    
    // MARK: - Computed Properties
    var isTitleEmpty: Bool { title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var formattedStartDate: String { startDate.formattedDate(with: "MMM d, yyyy") }
    var formattedEndDate: String { endDate.formattedDate(with: "MMM d, yyyy") }
    var formattedStartTime: String { formatTime(startTime) }
    var formattedEndTime: String { formatTime(endTime) }
    
    
    var showTagPicker: Bool = false // 어칼거니?
    
    
    // MARK: - Time Utilities
    
    // 날짜랑 시간 결합
    func combineDateAndTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: time)
        return calendar.date(
            bySettingHour: components.hour ?? 0,
            minute: components.minute ?? 0,
            second: components.second ?? 0,
            of: date
        ) ?? date
    }
    
    func formatDate(date: Date, time: Date) -> String {
        combineDateAndTime(date: date, time: time).formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }
    
    // All-Day 상태면 Time Picker에 All-Day 표시
    func formatTime(_ date: Date) -> String {
        isAllDay ? StringLiteral.AddSchedule.allDay : date.formattedDate(with: "h:mm a")
    }
    
    
    // MARK: - All-Day Handling
    
    // 사용자의 토글 여부
    private var hasUserToggledAllDay: Bool = false
    
    // 시작&종료 날짜 시간
    private var startDateTime: Date { combineDateAndTime(date: startDate, time: startTime) }
    private var endDateTime: Date { combineDateAndTime(date: endDate, time: endTime) }
    
    // 시작일과 종료일 간의 일(day) 차이
    private var dayDifference: Int {
        Calendar.current.dateComponents([.day],
                                        from: Calendar.current.startOfDay(for: startDate),
                                        to: Calendar.current.startOfDay(for: endDate)).day ?? 0
    }
    
    // 일정 기간이 하루 이상인지 여부
    func isOverOneDay() -> Bool {
        endDateTime.timeIntervalSince(startDateTime) >= .oneDay
    }
    
    // All-Day 토글
    func toggleAllDay() {
        guard dayDifference < 2 else {
            print("DEBUG: 2일 이상 일정은 All-Day 해제 불가")
            return
        }
        
        isAllDay.toggle()
        hasUserToggledAllDay = true
    }
    
    // All-Day 상태에 따라 시작/종료 시간을 자동으로 업데이트
    func updateTimeForAllDayStatus() {
        if isAllDay { // All-Day일 경우 시작/종료 시간을 날짜의 시작 시각으로 맞춤
            startTime = startDate.startOfDay
            endTime = endDate.startOfDay
        } else { // 올데이가 아닐 경우, 적절히 반올림된 시간으로 설정
            let start = Date().roundedToNearestHalfHour()
            let end = Calendar.current.date(byAdding: .hour, value: 2, to: start) ?? start
            
            startTime = start
            endTime = end
        }
    }
    
    // All-Day 상태가 활성화되어야 하는지 판단
    func autoUpdateAllDayStatus() {
        if hasUserToggledAllDay { return }
        
        let autoAllDay: Bool
        switch dayDifference {
        case 2...:
            autoAllDay = true
        case 1, 0:
            autoAllDay = isOverOneDay()
        default:
            autoAllDay = false
        }
        
        if isAllDay != autoAllDay {
            if isOverOneDay() && !isAllDay {
                print("DEBUG: 사용자가 All-Day를 해제했지만 일정 기간이 24시간 이상이므로 isAllDay: true로 전송됨")
            }
            isAllDay = autoAllDay
        }
    }
    
    
    // MARK: - API
    func getTagsAPI() {
        tagAPIService.getTags { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let tags = response?.data, !tags.isEmpty {
                
                self.tagList = tags.map { Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) }
                self.selectedTag = self.tagList.first ?? self.selectedTag
                self.tagId = self.selectedTag.tagId
            }
        }
    }
    
    func postAddSchedule(completion: @escaping () -> Void) {
        let body = SchedulePostRequest(
            description: title,
            startDate: formatDate(date: startDate, time: startTime),
            endDate: formatDate(date: endDate, time: endTime),
            isAllDay: isAllDay,
            tagId: selectedTag.tagId
        )
        
        scheduleAPIService.postSchedule(body: body) { _ in
            completion()
        }
    }
}
