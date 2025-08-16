//
//  AddTodoKeyboardToolbarItem.swift
//  Memento-iOS
//
//  Created by RAFA on 2/23/25.
//

import SwiftUI

import MDSKit

struct AddTodoKeyboardToolbarItem: View {
    
    @ObservedObject var viewModel: AddTodoViewModel
    var onEnter: () -> Void
    
    var body: some View {
        HStack {
            deadlineButton
            tagButton
            matrixButton
            Spacer()
            enterButton
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 15)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray10.ignoresSafeArea(.all))
    }
    
    var deadlineButton: some View {
        Button(action: {
            viewModel.showEndDatePicker = true
        }) {
            HStack {
                Image(.ic_deadline)
                
                Text(viewModel.formattedEndDate)
                    .applyFont(.detail_r_12)
            }
            .foregroundStyle(Color.gray02)
        }
        .frame(width: 86, height: 41)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $viewModel.showEndDatePicker) {
            SheetContainer(type: .addTodo(.date)) {
                VStack {
                    SheetOKButton { viewModel.showEndDatePicker = false }
                    
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
    
    var tagButton: some View {
        Button(action: {
            viewModel.showTagPicker = true
        }) {
            Circle()
                .fill(Color(viewModel.selectedTag.color))
                .frame(width: 10, height: 10)
        }
        .frame(width: 42, height: 42)
        .background(Color.gray09)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .sheet(isPresented: $viewModel.showTagPicker) {
            TagPickerSheet(
                viewModel: viewModel,
                //                isPresented: $viewModel.showTagPicker,
                type: .addTodo(.tag),
                tagList: viewModel.tags
            )
//            .onAppear {
//                viewModel.loadTags()
//            }
        }
    }
    
    var matrixButton: some View {
        Button(action: {
            viewModel.showPriorityPicker = true
        }) {
            Image(viewModel.getPriorityImage(viewModel.selectedPriority))
                .frame(width: 26, height: 26)
                .padding(8)
                .background(Color.gray09)
                .cornerRadius(2)
        }
        .frame(width: 42, height: 42)
        .sheet(isPresented: $viewModel.showPriorityPicker) {
            SheetContainer(type: .addTodo(.priority)) {
                AddTodoPriorityView(
                    viewType: .add,
                    source: "",
                    viewModel: viewModel
                )
            }
        }
    }
    
    var enterButton: some View {
        Button(action: {
            onEnter()
        }) {
            Image(viewModel.isTextEmpty ? .btn_enter_disabled : .btn_enter_active)
        }
        .disabled(viewModel.isTextEmpty)
    }
}
