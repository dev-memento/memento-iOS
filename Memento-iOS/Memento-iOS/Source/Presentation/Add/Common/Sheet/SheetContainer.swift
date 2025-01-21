//
//  SheetContainer.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct SheetContainer<Content: View>: View {

    let type: AddSchedulePickerButtonType
    let content: Content

    init(type: AddSchedulePickerButtonType, @ViewBuilder content: () -> Content) {
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
        .presentationDetents(DynamicPresentationDetent.dynamicDetent(for: type))
    }
}
