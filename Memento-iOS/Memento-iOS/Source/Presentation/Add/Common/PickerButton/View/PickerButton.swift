//
//  PickerButton.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct PickerButton: View {

    // MARK: - Properties

    let type: PickerButtonType
    let title: String
    let titleColor: Color
    let width: CGFloat
    let action: () -> Void

    @ObservedObject var viewModel: BasePickerViewModel

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            Text(title)
                .applyFont(.body_r_14)
                .foregroundColor(titleColor)
                .frame(width: width, height: 36)
                .background(viewModel.isPressed ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray10
            .ignoresSafeArea()

        VStack {
            PickerButton(
                type: .date,
                title: "Jan 31, 2025",
                titleColor: .gray02,
                width: 124,
                action: {},
                viewModel: PickerButtonViewModel()
            )

            PickerButton(
                type: .time,
                title: "8:53 AM",
                titleColor: .gray02,
                width: 96,
                action: {},
                viewModel: PickerButtonViewModel()
            )

            PickerButton(
                type: .tag,
                title: "Select Tag",
                titleColor: .gray02,
                width: 200,
                action: {},
                viewModel: PickerButtonViewModel()
            )
        }
    }
}
