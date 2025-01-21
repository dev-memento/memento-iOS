//
//  AddTodoBottomView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddTodoBottomView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: AddTodoTextViewModel

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                HStack {
                    Image(.ic_deadline)

                    Text("Today")
                }
                .foregroundStyle(Color.gray02)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.gray09)
                .cornerRadius(2)
            }

            Button(action: {}) {
                Image(.ic_tag)
                    .padding(14)
                    .background(Color.gray09)
                    .cornerRadius(2)
            }
            .frame(width: 42, height: 42)

            Button(action: {}) {
                Image(.matrix_none)
                    .frame(width: 26, height: 26)
                    .padding(8)
                    .background(Color.gray09)
                    .cornerRadius(2)
            }
            .frame(width: 42, height: 42)

            Spacer()

            enterButton
        }
        .padding(.bottom, 20)
    }

    // MARK: - UI Components

    private var enterButton: some View {
        Button(action: {
        }) {
            Image(
                viewModel.isTextEmpty
                ? .btn_enter_disabled
                : .btn_enter_active
            )
        }
        .disabled(viewModel.isTextEmpty)
    }
}

// MARK: - Preview

#Preview {
    AddTodoBottomView(viewModel: AddTodoTextViewModel())
}
