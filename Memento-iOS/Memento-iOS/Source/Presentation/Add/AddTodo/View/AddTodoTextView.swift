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
    @ObservedObject var segmentedViewModel: SegmentedMenuViewModel

    @FocusState private var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0

    // MARK: - Body

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        TextField("", text: $viewModel.description, axis: .vertical)
                            .applyFont(.body_b_16)
                            .tint(.mainGreen)
                            .padding(.bottom, keyboardHeight)
                            .foregroundStyle(Color.grayWhite)
                            .lineLimit(nil)
                            .focused($isFocused)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .id("TextFieldBottomAnchor")
                            .onAppear {
                                DispatchQueue.main.async {
                                    isFocused = true
                                }
                            }
                            .onDisappear {
                                DispatchQueue.main.async {
                                    isFocused = false
                                }
                            }
                            .onChange(of: viewModel.description) { _, newText in
                                viewModel.limitTextLength(newText)
                                scrollToBottom(proxy: proxy)
                            }
                    }
                }
                .onAppear { setupKeyboardObservers(proxy: proxy) }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                AddTodoKeyboardToolbarItem(viewModel: viewModel, segmentedViewModel: segmentedViewModel)
            }
        }
    }

    // MARK: - Helpers

    private func setupKeyboardObservers(proxy: ScrollViewProxy) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as? CGRect {
                keyboardHeight = keyboardFrame.height + 30

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scrollToBottom(proxy: proxy)
                }
            }
        }

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        proxy.scrollTo("TextFieldBottomAnchor", anchor: .bottom)
    }
}
