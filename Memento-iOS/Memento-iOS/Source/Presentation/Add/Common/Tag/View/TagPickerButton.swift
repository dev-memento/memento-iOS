//
//  TagPickerButton.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct TagPickerButton: View {

    // MARK: - Properties

    @Binding var isPressed: Bool
    @Binding var isPresented: Bool
    let viewModel: PickerButtonViewModel

    // MARK: - Body
    var body: some View {
        Button {
            isPresented.toggle()
            isPressed = true
        } label: {
            HStack(spacing: 5) {
                Circle()
                    .fill(viewModel.selectedTag.color)
                    .frame(width: 14, height: 14)

                Text(
                    viewModel.selectedTag.title.isEmpty
                    ? "Untitled"
                    : viewModel.selectedTag.title
                )
                .applyFont(.body_r_14)
                .foregroundColor(.gray02)
            }
            .frame(width: 200, height: 36)
            .background(isPressed ? Color.gray07 : Color.gray09)
            .cornerRadius(2)
        }
    }
}
