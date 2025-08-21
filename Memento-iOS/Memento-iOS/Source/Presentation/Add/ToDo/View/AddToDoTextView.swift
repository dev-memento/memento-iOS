//
//  AddToDoTextView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI
import Combine

struct AddToDoTextView: View {
    
    @ObservedObject var viewModel: AddToDoViewModel
    
    @FocusState private var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
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
                        .onAppear { isFocused = true }
                        .onDisappear { isFocused = false }
                        .onChange(of: viewModel.description) {
                            scrollToBottom(proxy: proxy)
                        }
                }
            }
            .onAppear {
                scrollToBottom(proxy: proxy)
            }
            .onReceive(Publishers.keyboardHeight) { height in
                keyboardHeight = height + 30
                scrollToBottom(proxy: proxy)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                AddToDoToolbarView(viewModel: viewModel)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        withAnimation(animated ? .easeOut(duration: 0.2) : nil) {
            proxy.scrollTo("TextFieldBottomAnchor", anchor: .bottom)
        }
    }
}

// MARK: - Keyboard Publisher

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return willShow
            .merge(with: willHide)
            .eraseToAnyPublisher()
    }
}
