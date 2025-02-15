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

    @ObservedObject var viewModel: AddTodoViewModel
    @FocusState private var isFocused: Bool

    // MARK: - Body

    var body: some View {
        TextField("", text: $viewModel.description, axis: .vertical)
            .applyFont(.body_b_16)
            .tint(.mainGreen)
            .foregroundStyle(Color.grayWhite)
            .lineLimit(nil)
            .textFieldStyle(.plain)
            .focused($isFocused)
            .onAppear { isFocused = true }
            .onChange(of: viewModel.description) { _, newText in
                viewModel.limitTextLength(newText)
            }
    }
}
