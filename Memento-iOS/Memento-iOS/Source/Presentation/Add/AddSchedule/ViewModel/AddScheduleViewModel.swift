import SwiftUI

import MDSKit

final class AddScheduleViewModel: ObservableObject, TagSelectable {

    // MARK: - Dependencies

    private var scheduleApiService: ScheduleAPIService

    // MARK: - Input

    @Published var title: String = ""
    @Published var selectedTag: Tag
    @Published var tagList: [Tag]
    @Published var isAllDay: Bool {
        didSet {
            if isManualAllDayChangeAllowed {
                isAllDayManuallyToggled = true
            }
            updateTimesForAllDayStatus()
        }
    }

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

    // MARK: - Properties

    var isTitleEmpty: Bool { title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var formattedStartDate: String { startDate.formattedDate(with: "MMM d, yyyy") }
    var formattedEndDate: String { endDate.formattedDate(with: "MMM d, yyyy") }
    var formattedStartTime: String { formatTimeString(startTime) }
    var formattedEndTime: String { formatTimeString(endTime) }

    private var isManualAllDayChangeAllowed: Bool { numberOfDayDifference() < 2 }
    private var isAllDayManuallyToggled: Bool = false

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
        self.selectedTag = Tag(tagId: 187, color: Color(hex: "#A9ADBB"), title: "Untitled")
        self.tagList = []
    }

    // MARK: - API

    func postAddSchedule(completion: @escaping () -> Void) {
        let shouldBeAllDay = isEventLongerThan24Hours() || isAllDay

         if isEventLongerThan24Hours() && !isAllDay {
             print("DEBUG: 이벤트 기간이 24시간 이상이지만 사용자가 all-day를 해제했습니다. API에는 isAllDay: true로 전송됩니다.")
         }

        let request = PostCreateScheduleRequest(
            description: title,
            startDate: combine(date: startDate, time: startTime).formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
            endDate: combine(date: endDate, time: endTime).formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
            isAllDay: shouldBeAllDay,
            tagID: selectedTag.tagId == 0 ? 1 : selectedTag.tagId
        )

        print("DEBUG: request - \(request)")

        scheduleApiService.postCreateSchedule(bodyParam: request) { [weak self] result in
            guard let self else { return }

            self.postMakeScheduleNotiFication()
            completion()
            print("DEBUG: result - \(result)")
        }
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

    // MARK: - User Interaction

    func toggleAllDay() {
        guard isManualAllDayChangeAllowed else {
            print("DEBUG: 2일 이상 일정은 올데이 해제 불가")
            return
        }

        isAllDay.toggle()
        isAllDayManuallyToggled = true
    }

    // MARK: - Time & Date

    func isEventLongerThan24Hours() -> Bool {
        let start = combine(date: startDate, time: startTime)
        let end = combine(date: endDate, time: endTime)

        return end.timeIntervalSince(start) >= .secondsInADay
    }
}

// MARK: - Private Methods

private extension AddScheduleViewModel {

    // MARK: Notification

    func postMakeScheduleNotiFication() {
        NotificationCenter.default.post(
            name: NSNotification.Name("postScheduleComplete"),
            object: nil,
            userInfo: nil
        )
    }

    // MARK: Time Handling

    func updateTimesForAllDayStatus() {
        if isAllDay {
            startTime = startDate.startOfDay
            endTime = endDate.startOfDay
        } else {
            guard let (roundedStart, roundedEnd) = Self.makeRoundedStartAndEnd() else { return }

            startTime = roundedStart
            endTime = roundedEnd
        }
    }

    func checkIfAllDayShouldBeEnabled() {
        let dayDifference = numberOfDayDifference()
        let start = combine(date: startDate, time: startTime)
        let end = combine(date: endDate, time: endTime)
        let interval = end.timeIntervalSince(start)
        let shouldBeAllDay: Bool

        switch dayDifference {
        case 2...:
            shouldBeAllDay = true
        case 1, 0:
            if isAllDayManuallyToggled { return }
            shouldBeAllDay = interval >= .secondsInADay
        default:
            shouldBeAllDay = false
        }

        if isAllDay != shouldBeAllDay {
            isAllDay = shouldBeAllDay
        }
    }

    // MARK: Date Utilities

    func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)

        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        dateComponents.second = timeComponents.second

        return calendar.date(from: dateComponents) ?? date
    }

    func numberOfDayDifference() -> Int {
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: startDate)
        let endDay = calendar.startOfDay(for: endDate)
        return calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0
    }

    // MARK: Formatter

    func formatTimeString(_ date: Date) -> String {
        isAllDay ? StringLiteral.AddSchedule.allDay : date.formattedDate(with: "h:mm a")
    }

    // MARK: Factory

    static func makeRoundedStartAndEnd() -> (Date, Date)? {
        let start = Date().roundedToNearestHalfHour()
        guard let end = Calendar.current.date(byAdding: .hour, value: 2, to: start) else {
            return nil
        }

        return (start, end)
    }
}
