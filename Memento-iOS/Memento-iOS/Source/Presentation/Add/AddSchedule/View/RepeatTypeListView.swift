//
//  RepeatTypeListView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct RepeatTypeListView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: PickerButtonViewModel

    // MARK: - Body

    var body: some View {
        VStack {
            ForEach(RepeatType.allCases, id: \.self) { type in
                Button(action: { viewModel.updateRepeatType(type) }) {
                    Text(type.title)
                        .applyFont(.body_r_14)
                        .foregroundColor(
                            viewModel.repeatType == type
                            ? .gray02
                            : .gray07
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            viewModel.repeatType == type
                            ? Color.gray08
                            : Color.clear
                        )
                        .cornerRadius(2)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    RepeatTypeListView(
        viewModel: PickerButtonViewModel()
    )
}
