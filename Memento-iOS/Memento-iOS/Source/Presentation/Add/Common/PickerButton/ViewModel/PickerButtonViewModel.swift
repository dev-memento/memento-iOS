//
//  PickerButtonViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

final class PickerButtonViewModel: BasePickerViewModel {

    // MARK: - Properties

    @Published private(set) var selection: DateTimeSelection
    @Published var selectedDate: Date = Date()
    @Published var isAllDay: Bool = false
    @Published var repeatType: RepeatType = .none
    @Published var shouldShowEndRepeat: Bool = false
    @Published var endRepeatDate: Date?
    @Published var isEndRepeatDateSelected: Bool = false
    @Published var selectedTag: Tag = Tag.mockData.first!

    let pickerType: PickerButtonType
    private let initialStartTime: Date
    private let initialEndTime: Date

    // MARK: - Initializer

    init(type: PickerButtonType = .date) {
        let now = Date()
        self.pickerType = type
        self.initialStartTime = now
        self.initialEndTime = now

        self.selection = DateTimeSelection(
            startsDate: now,
            endsDate: now,
            isAllDay: false,
            selectedStartTime: now,
            selectedEndTime: now
        )
        super.init()
    }

    // MARK: - Computed properties

    var startsDate: Date {
        get { selection.startsDate }
        set {
            selection.startsDate = newValue
            validateAndUpdateDates()
        }
    }

    var endsDate: Date {
        get { selection.endsDate }
        set {
            selection.endsDate = newValue
            validateAndUpdateDates()
        }
    }

    var selectedStartTime: Date {
        get { selection.selectedStartTime }
        set { selection.selectedStartTime = newValue }
    }

    var selectedEndTime: Date {
        get { selection.selectedEndTime }
        set { selection.selectedEndTime = newValue }
    }

    var formattedStartTime: String {
        formatTimeString(selection.selectedStartTime)
    }

    var formattedEndTime: String {
        formatTimeString(selection.selectedEndTime)
    }

    var formattedPickerTitle: String {
        switch pickerType {
        case .date:
            return selectedDate.formattedDate(with: "MMM d, yyyy")
        case .endRepeat:
            return isEndRepeatDateSelected
            ? (endRepeatDate ?? selectedDate).formattedDate(with: "MMM d, yyyy")
            : "Select Date"
        case .repeat:
            return repeatType.title
        case .time:
            return selectedDate.formattedDate(with: "h:mm a")
        case .tag:
            return selectedTag.title.isEmpty ? "Untitled" : selectedTag.title
        }
    }

    var titleColor: Color {
        if pickerType == .endRepeat && !isEndRepeatDateSelected {
            return .mementoBlue
        }
        return .gray02
    }

    // MARK: - Override methods

    override func togglePresentation() {
        if !isAllDay {
            super.togglePresentation()
        }
    }

    override func dismiss() {
        super.dismiss()
        setPressedState(false)

        if pickerType == .endRepeat {
            isEndRepeatDateSelected = true
        }
    }

    // MARK: - Public Methods

    func confirmSelection() {
        if pickerType == .repeat {
            updateRepeatType(repeatType)
        }
        dismiss()
    }

    func updateRepeatType(_ type: RepeatType) {
        repeatType = type
        shouldShowEndRepeat = type != .none
        if type == .none {
            endRepeatDate = nil
            isEndRepeatDateSelected = false
        }
    }

    func updateEndRepeatDate(_ date: Date) {
        endRepeatDate = date
        isEndRepeatDateSelected = true
    }

    func resetToInitialTime() {
        selection.selectedStartTime = initialStartTime
        selection.selectedEndTime = initialEndTime
    }

    // MARK: - Private methods

    private func formatTimeString(_ date: Date) -> String {
        isAllDay ? "All-day" : date.formattedDate(with: "h:mm a")
    }

    private func validateAndUpdateDates() {
        if selection.endsDate < selection.startsDate {
            selection.endsDate = selection.startsDate
        }

        if !isAllDay && selection.selectedEndTime < selection.selectedStartTime {
            selection.selectedEndTime = selection.selectedStartTime
        }
    }

    private func updateTimesForAllDayStatus(_ isAllDay: Bool) {
        if isAllDay {
            selection.selectedStartTime = Calendar.current.startOfDay(for: selection.startsDate)
            selection.selectedEndTime = Calendar.current.startOfDay(for: selection.endsDate)
        } else {
            resetToInitialTime()
        }
    }
}
