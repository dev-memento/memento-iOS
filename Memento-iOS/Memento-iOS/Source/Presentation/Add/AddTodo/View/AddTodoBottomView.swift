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

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddTodoViewModel

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
    }

    // MARK: - UI Components

    private var deadlineButton: some View {
        Button(action: {
            viewModel.showEndDatePicker = true
        }) {
            HStack {
                Image(.ic_deadline)

                Text(viewModel.formattedEndDate)
                    .applyFont(.detail_r_12)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.gray02)
        }
        .frame(width: 86, height: 41)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $viewModel.showEndDatePicker) {
            SheetContainer(type: .addTodo(.date)) {
                VStack {
                    SheetHeaderView {
                        viewModel.showEndDatePicker = false
                    }
                    DatePicker(
                        "",
                        selection: $viewModel.endDate,
                        displayedComponents: .date
                    )
                    .colorScheme(.dark)
                    .datePickerStyle(.graphical)
                    .tint(.mementoBlue)
                    .padding([.horizontal, .bottom], 10)
                }
            }
        }
    }

    private var tagButton: some View {
        Button(action: {
            viewModel.showTagPicker.toggle()
        }) {
            Circle()
                .fill(Color(viewModel.selectedTag.color))
                .frame(width: 10, height: 10)
        }
        .frame(width: 42, height: 42)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $viewModel.showTagPicker) {
            SheetContainer(type: .addTodo(.tag)) {
                SheetHeaderView {
                    viewModel.showTagPicker = false
                }
                List {
                    ForEach(Tag.mockData) { tag in
                        TagListItem(tag: tag, viewModel: viewModel)
                            .listRowBackground(
                                viewModel.selectedTag.tagId == tag.tagId
                                ? Color.gray08
                                : Color.clear
                            )
                    }
                }
                .listStyle(PlainListStyle())
                .ignoresSafeArea()
                .padding([.horizontal, .bottom], 10)
                .scrollDisabled(Tag.mockData.count <= 3)
            }
            .applyDynamicSheetForTagCount()
        }
    }

    private var matrixButton: some View {
        Button(action: {
            viewModel.showPriorityPicker.toggle()
        }) {
            Image(viewModel.getPriorityImage(viewModel.selectedPriority))
                .frame(width: 26, height: 26)
                .padding(8)
                .background(Color.gray09)
                .cornerRadius(2)
        }
        .frame(width: 42, height: 42)
        .sheet(isPresented: $viewModel.showPriorityPicker) {
            EisenhowerMatrixView(
                viewType: .add,
                source: "",
                viewModel: viewModel
            )
        }
    }

    private var enterButton: some View {
        Button(action: {
            viewModel.createTodo {
                viewModel.postMakeScheduleNotiFication()
                dismiss()
            }
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
