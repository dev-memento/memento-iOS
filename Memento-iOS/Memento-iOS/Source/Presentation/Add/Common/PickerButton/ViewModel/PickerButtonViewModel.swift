//
//  PickerButtonViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class PickerButtonViewModel: BasePickerViewModel {

    @Published var selectedDate: Date = Date()
    @Published var isAllDay: Bool = false

    override func togglePresentation() {
        if !isAllDay {
            super.togglePresentation()
        }
    }

    override func dismiss() {
        super.dismiss()
        setPressedState(false)
    }
}
