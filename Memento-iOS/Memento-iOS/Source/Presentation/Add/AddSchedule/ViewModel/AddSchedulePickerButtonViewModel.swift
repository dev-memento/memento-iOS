//
//  AddSchedulePickerButtonViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

final class AddSchedulePickerButtonViewModel: BasePickerViewModel {

    // MARK: - Properties

    @Published private(set) var selection: DateTimeSelection
    @Published var selectedDate: Date = Date()
    @Published var isAllDay: Bool = false
    @Published var selectedTag: Tag = Tag.mockData.first ?? Tag(color: .gray02, title: "Untitled")

    let pickerType: AddSchedulePickerButtonType
    private let initialStartTime: Date
    private let initialEndTime: Date

    // MARK: - Initializer

    init(type: AddSchedulePickerButtonType = .date) {
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
        case .time:
            return selectedDate.formattedDate(with: "h:mm a")
        case .tag:
            return selectedTag.title.isEmpty ? "Untitled" : selectedTag.title
        }
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
    }

    // MARK: - Public Methods

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
