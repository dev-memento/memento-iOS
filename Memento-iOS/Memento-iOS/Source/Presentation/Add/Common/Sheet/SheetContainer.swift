//
//  SheetContainer.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct SheetContainer<Content: View, ButtonType>: View {

    let type: ButtonType
    let content: Content

    init(type: ButtonType, @ViewBuilder content: () -> Content) {
        self.type = type
        self.content = content()
    }

    var body: some View {
        VStack {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray09)
        .presentationCornerRadius(0)
        .presentationDragIndicator(.hidden)
        .presentationDetents(dynamicDetentForType(type))
    }

    private func dynamicDetentForType(_ type: ButtonType) -> Set<PresentationDetent> {
        if case let scheduleType as AddSchedulePickerButtonType = type {
            return DynamicPresentationDetent.dynamicDetent(for: scheduleType)
        } else if case let todoType as AddTodoPickerButtonType = type {
            return DynamicPresentationDetent.dynamicDetent(for: todoType)
        }
        return [.fraction(0.5)]
    }
}
