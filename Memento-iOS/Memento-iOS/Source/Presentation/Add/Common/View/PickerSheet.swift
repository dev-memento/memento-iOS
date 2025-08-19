//
//  PickerSheet.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct PickerSheet<Content: View>: View {

    let type: PickerButtonType
    let content: Content

    init(type: PickerButtonType, @ViewBuilder content: () -> Content) {
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
