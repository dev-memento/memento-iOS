//
//  AddTodoHeaderViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class AddTodoHeaderViewModel: ObservableObject {

    @Published var showDatePicker: Bool = false
    @Published var selectedDate: Date = Date() {
        didSet {
            updateFormattedDate()
        }
    }
    @Published var formattedDate: String = "Today"
    
    var isoFormattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone.current
        isoFormatter.formatOptions = [.withFullDate]
        return isoFormatter.string(from: selectedDate)
    }

    init() {
        updateFormattedDate()
    }

    private func updateFormattedDate() {
        let calendar = Calendar.current
        if calendar.isDateInToday(selectedDate) {
            formattedDate = "Today"
        } else {
            formattedDate = selectedDate.formattedDate(with: "MMM d")
        }
    }
}
