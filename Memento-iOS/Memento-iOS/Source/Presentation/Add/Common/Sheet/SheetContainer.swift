//
//  SheetContainer.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct SheetContainer<Content: View>: View {

    let height: CGFloat
    let content: Content

    init(height: CGFloat, @ViewBuilder content: () -> Content) {
        self.height = height
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
        .presentationDetents([.height(height)])
    }
}
