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
    
    @Published var selectedDate: Date = Date()
    @Published var selectedTag: Tag = Tag.mockData.first ?? Tag(color: .gray02, title: "Untitled")

    let pickerType: AddTodoPickerButtonType

    // MARK: - Initializer

    init(type: AddTodoPickerButtonType = .tag) {
        self.pickerType = type
        super.init()
    }

    // MARK: - Computed properties

    var formattedPickerTitle: String {
        switch pickerType {
        case .tag:
            return selectedTag.title.isEmpty ? "Untitled" : selectedTag.title
        case .date, .deadline:
            return Calendar.current.isDateInToday(selectedDate)
                ? "Today"
                : selectedDate.formattedDate(with: "MMM d")
        }
    }

    // MARK: - Override methods

    override func dismiss() {
        super.dismiss()
        setPressedState(false)
    }
}

// MARK: - Protocols

extension AddTodoPickerButtonViewModel: TagSelectable {

    func updateSelectedTag(_ tag: Tag) {
        selectedTag = tag
    }
}
