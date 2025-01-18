//
//  AddTodoTextView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddTodoTextView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddTodoTextViewModel
    @FocusState private var isFocused: Bool

    // MARK: - Body

    var body: some View {
        TextField("", text: $viewModel.text, axis: .vertical)
            .applyFont(.body_b_16)
            .tint(.mainGreen)
            .foregroundStyle(Color.grayWhite)
            .lineLimit(nil)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .onAppear { isFocused = true }
            .onChange(of: viewModel.text) { _, newText in
                viewModel.limitTextLength(newText)
            }
    }
}

// MARK: - Preview

#Preview {
    AddTodoTextView(viewModel: AddTodoTextViewModel())
}
