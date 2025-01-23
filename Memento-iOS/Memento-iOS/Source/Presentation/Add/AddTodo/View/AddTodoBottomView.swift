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
    @ObservedObject var todoViewModel: AddTodoViewModel
    @State private var isDeadlinePresented: Bool = false
    @State private var isTagPresented: Bool = false
    @State private var isMatrixPresented: Bool = false
    @State private var selectedDateText: String = "Today"
    @State private var selectedTagColor: Color = .gray05
    @StateObject private var deadlineViewModel = AddTodoPickerButtonViewModel(type: .deadline)
    @StateObject private var tagViewModel = AddTodoPickerButtonViewModel(type: .tag)

    // MARK: - Body

    var body: some View {
        HStack(spacing: 8) {
            deadlineButton
            tagButton
            matrixButton
            Spacer()
            enterButton
        }
        .padding(.bottom, 20)
        .onChange(of: viewModel.text) { _, newText in
            todoViewModel.description = newText
        }
    }

    // MARK: - UI Components

    private var deadlineButton: some View {
        Button(action: {
            isDeadlinePresented.toggle()
        }) {
            HStack {
                Image(.ic_deadline)

                Text(deadlineViewModel.formattedPickerTitle)
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
                viewModel: deadlineViewModel,
                selectedDateText: $selectedDateText
            )
            .presentationDetents(
                DynamicPresentationDetent.dynamicDetent(for: .deadline)
            )
        }
    }

    private var tagButton: some View {
        Button(action: {
            isTagPresented.toggle()
        }) {
            Circle()
                .fill(Color(tagViewModel.selectedTag.color))
                .frame(width: 10, height: 10)
        }
        .frame(width: 42, height: 42)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $isTagPresented) {
            AddTagView(viewModel: tagViewModel)
                .presentationDetents(
                    DynamicPresentationDetent.dynamicDetent(
                        for: AddTodoPickerButtonType.tag
                    )
                )
        }
    }

    private var matrixButton: some View {
        Button(action: {
            isMatrixPresented.toggle()
        }) {
            Image(.matrix_none)
                .frame(width: 26, height: 26)
                .padding(8)
                .background(Color.gray09)
                .cornerRadius(2)
        }
        .frame(width: 42, height: 42)
        .sheet(isPresented: $isMatrixPresented) {
            EisenhowerMatrixView(
                source: "",
                externalPriority: .constant(.none)
            )
        }
    }

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
