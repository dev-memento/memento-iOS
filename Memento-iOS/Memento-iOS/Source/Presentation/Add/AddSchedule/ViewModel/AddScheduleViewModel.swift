import SwiftUI

import MDSKit

final class AddScheduleViewModel: ObservableObject, TagSelectable {

    // MARK: - Dependencies

    private var scheduleApiService: ScheduleAPIService

    // MARK: - Input

    @Published var title: String = ""
    @Published var selectedTag: Tag
    @Published var isAllDay: Bool { didSet { updateTimesForAllDayStatus() } }
    @Published var isNaturalLanguageInputEnabled: Bool = false

    // MARK: - Date & Time

    @Published var startDate: Date { didSet { checkIfAllDayShouldBeEnabled() } }
    @Published var startTime: Date { didSet { checkIfAllDayShouldBeEnabled() } }
    @Published var endDate: Date { didSet { checkIfAllDayShouldBeEnabled() } }
    @Published var endTime: Date { didSet { checkIfAllDayShouldBeEnabled() } }

    // MARK: - Sheet State

    @Published var isStartDatePressed: Bool = false
    @Published var isStartTimePressed: Bool = false
    @Published var isEndDatePressed: Bool = false
    @Published var isEndTimePressed: Bool = false
    @Published var isTagPressed: Bool = false

    @Published var isStartDatePickerPresented: Bool = false
    @Published var isEndDatePickerPresented: Bool = false
    @Published var isStartTimePickerPresented: Bool = false
    @Published var isEndTimePickerPresented: Bool = false
    @Published var isTagPickerPresented: Bool = false

    // MARK: - Computed Properties

    var isTitleEmpty: Bool { title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var formattedStartDate: String { startsDate.formattedDate(with: "MMM d, yyyy") }
    var formattedEndDate: String { endsDate.formattedDate(with: "MMM d, yyyy") }
    var formattedStartTime: String { formatTimeString(selectedStartTime) }
    var formattedEndTime: String { formatTimeString(selectedEndTime) }

    // MARK: - Initializer

    init(scheduleApiService: ScheduleAPIService = ScheduleAPIService()) {
        guard let (roundedStart, roundedEnd) = Self.makeRoundedStartAndEnd() else {
            fatalError("DEBUG: 시간 계산에 실패했습니다.")
        }

        self.scheduleApiService = scheduleApiService
        self.startDate = roundedStart
        self.startTime = roundedStart
        self.endDate = roundedEnd
        self.endTime = roundedEnd
        self.isAllDay = false
        self.selectedTag = Tag.mockData.first ?? Tag(tagId: 0, color: .gray02, title: "Untitled")
    }

    // MARK: - API

    func postAddSchedule(completion: @escaping () -> Void) {
        let body = PostCreateScheduleRequest(
            description: title,
            startDate: formatDateTime(date: startsDate, time: selectedStartTime),
            endDate: formatDateTime(date: endsDate, time: selectedEndTime),
            isAllDay: isAllDay,
            tagID: selectedTag.tagId == 0 ? 1 : selectedTag.tagId
        )

        print("DEBUG: \(body)")

        scheduleApiService.postCreateSchedule(bodyParam: body) { [weak self] result in
            guard let self else { return }

            self.postMakeScheduleNotiFication()
            completion()
        }
    }
    
    func postMakeScheduleNotiFication() {
        NotificationCenter.default.post(
            name: NSNotification.Name("postScheduleComplete"),
            object: nil,
            userInfo: nil
        )
    }

    // MARK: - Sheet Control

    func presentDatePicker(type: AddScheduleSectionType) {
        switch type {
        case .start:
            isStartDatePickerPresented = true
            isStartDatePressed = true
        case .end:
            isEndDatePickerPresented = true
            isEndDatePressed = true
        }
    }

    func dismissDatePicker(type: AddScheduleSectionType) {
        switch type {
        case .start:
            isStartDatePickerPresented = false
            isStartDatePressed = false
        case .end:
            isEndDatePickerPresented = false
            isEndDatePressed = false
        }
    }

    func presentTimePicker(type: AddScheduleSectionType) {
        guard !isAllDay else { return }

        switch type {
        case .start:
            isStartTimePickerPresented = true
            isStartTimePressed = true
        case .end:
            isEndTimePickerPresented = true
            isEndTimePressed = true
        }
    }

    func dismissTimePicker(type: AddScheduleSectionType) {
        switch type {
        case .start:
            isStartTimePickerPresented = false
            isStartTimePressed = false
        case .end:
            isEndTimePickerPresented = false
            isEndTimePressed = false
        }
    }

    func presentTagPicker() {
        isTagPickerPresented = true
        isTagPressed = true
    }

    func dismissTagPicker() {
        isTagPickerPresented = false
        isTagPressed = false
    }

    func toggleAllDay() {
        isAllDay.toggle()
    }

    // MARK: - Helpers

    private func updateTimesForAllDayStatus() {
        if isAllDay {
            startTime = startDate.startOfDay
            endTime = endDate.startOfDay
        } else {
            guard let (roundedStart, roundedEnd) = Self.makeRoundedStartAndEnd() else { return }

            startTime = roundedStart
            endTime = roundedEnd
        }
    }

    private func formatTimeString(_ date: Date) -> String {
        isAllDay ? StringLiteral.AddSchedule.allDay : date.formattedDate(with: "h:mm a")
    }

    private func formatDateTime(date: Date, time: Date) -> String {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second

        let combinedDate = calendar.date(from: components) ?? date
        return combinedDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }

    private static func makeRoundedStartAndEnd() -> (Date, Date)? {
        let start = Date().roundedToNearestHalfHour()
        guard let end = Calendar.current.date(byAdding: .hour, value: 2, to: start) else {
            return nil
        }

        return (start, end)
    }
}
