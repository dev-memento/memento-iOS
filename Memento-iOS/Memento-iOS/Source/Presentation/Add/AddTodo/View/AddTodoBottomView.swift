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
    @State private var isDeadlinePresented: Bool = false
    @State private var selectedDateText: String = "Today"
    @StateObject private var pickerViewModel = PickerButtonViewModel(type: .deadline)

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                isDeadlinePresented.toggle()
            }) {
                HStack {
                    Image(.ic_deadline)

                    Text(pickerViewModel.formattedPickerTitle)
                        .applyFont(.detail_r_12)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.gray02)
            }
            .frame(width: 86, height: 41)
            .background(Color.gray09)
            .clipShape(RoundedRectangle(cornerRadius: 2))
            .sheet(isPresented: $isDeadlinePresented) {
                AddDeadlineView(
                    viewModel: pickerViewModel,
                    selectedDateText: $selectedDateText
                )
                .presentationDetents(
                    DynamicPresentationDetent.dynamicDetent(for: .deadline)
                )
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
