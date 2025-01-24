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
    @StateObject var bottomViewModel: AddTodoPickerButtonViewModel
    @State private var isDeadlinePresented: Bool = false
    @State private var isTagPresented: Bool = false
    @State private var isMatrixPresented: Bool = false
    @State private var selectedDateText: String = "Today"
    @State private var selectedTagColor: Color = .gray05
    @State private var selectedPriority: Priority = .none
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
        .onChange(of: bottomViewModel.selectedDate) { _, newDate in
            todoViewModel.endDate = bottomViewModel.isoFormattedDate
        }
        .onChange(of: bottomViewModel.selectedTag) { _, newTag in
            todoViewModel.tagId = newTag.tagId
        }
        .onChange(of: selectedPriority) { _, newValue in
            todoViewModel.selectedPriority = newValue
        }
    }

    // MARK: - UI Components

    private var deadlineButton: some View {
        Button(action: {
            isDeadlinePresented.toggle()
        }) {
            HStack {
                Image(.ic_deadline)

                Text(bottomViewModel.formattedPickerTitle)
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
                viewModel: bottomViewModel,
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
                .fill(Color(bottomViewModel.selectedTag.color))
                .frame(width: 10, height: 10)
        }
        .frame(width: 42, height: 42)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $isTagPresented) {
            AddTagView(viewModel: bottomViewModel)
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
            Image(getPriorityImage(selectedPriority))
                .frame(width: 26, height: 26)
                .padding(8)
                .background(Color.gray09)
                .cornerRadius(2)
        }
        .frame(width: 42, height: 42)
        .sheet(isPresented: $isMatrixPresented) {
            EisenhowerMatrixView(
                viewType: .add,
                source: "",
                externalPriority: $selectedPriority
            )
        }
    }

    private var enterButton: some View {
        Button(action: {
            todoViewModel.createTodo()
        }) {
            Image(
                viewModel.isTextEmpty
                ? .btn_enter_disabled
                : .btn_enter_active
            )
        }
        .disabled(viewModel.isTextEmpty)
    }

    // MARK: - Helpers

    private func getPriorityImage(_ priority: Priority) -> MDSImageName {
        switch priority {
        case .immediate: return .matrix_immediate
        case .high: return .matrix_high
        case .medium: return .matrix_medium
        case .low: return .matrix_low
        case .none: return .matrix_none
        }
    }
}
