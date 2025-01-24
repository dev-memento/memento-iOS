//
//  AddTodoPickerButtonViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/22/25.
//

import SwiftUI

import MDSKit

final class AddTodoPickerButtonViewModel: BasePickerViewModel {
    
    // MARK: - Properties
    
    @Published var selectedDate: Date = Date() {
        didSet {
            updateFormattedPickerTitle()
        }
    }

    @Published var selectedTag: Tag = Tag(tagId: 1, color: .gray05, title: "Untitled")
    @Published var formattedPickerTitle: String = "Today"

    let pickerType: AddTodoPickerButtonType

    // MARK: - Initializer

    init(type: AddTodoPickerButtonType = .tag) {
        self.pickerType = type
        super.init()
        updateFormattedPickerTitle()
    }

    // MARK: - Computed properties

    var isoFormattedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.timeZone = TimeZone.current
        isoFormatter.formatOptions = [.withFullDate]
        return isoFormatter.string(from: selectedDate)
    }

    // MARK: - Override methods

    override func dismiss() {
        super.dismiss()
        setPressedState(false)
    }

    // MARK: - Private Methods

    private func updateFormattedPickerTitle() {
        switch pickerType {
        case .tag:
            formattedPickerTitle = selectedTag.title
        case .date, .deadline:
            let calendar = Calendar.current
            if calendar.isDateInToday(selectedDate) {
                formattedPickerTitle = "Today"
            } else {
                formattedPickerTitle = selectedDate.formattedDate(with: "MMM d")
            }
        }
    }
}

// MARK: - Protocols

extension AddTodoPickerButtonViewModel: TagSelectable {

    func updateSelectedTag(_ tag: Tag) {
        selectedTag = tag
    }
}
