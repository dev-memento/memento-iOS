//
//  BasePickerViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

class BasePickerViewModel: ObservableObject, Presentable {

    @Published var isPresented: Bool = false
    @Published var isPressed: Bool = false

    func togglePresentation() {
        isPresented.toggle()
        isPressed = isPresented
    }

    func setPressedState(_ pressed: Bool) {
        isPressed = pressed
    }

    func dismiss() {
        isPresented = false
        isPressed = false
    }
}
