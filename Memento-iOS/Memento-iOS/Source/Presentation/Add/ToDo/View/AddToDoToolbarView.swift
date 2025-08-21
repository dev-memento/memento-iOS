//
//  AddToDoToolbarView.swift
//  Memento-iOS
//
//  Created by RAFA on 2/23/25.
//

import SwiftUI

import MDSKit

struct AddToDoToolbarView: View {
    
    @ObservedObject var viewModel: AddToDoViewModel
    
    @Binding var isAddViewPresented: Bool
    
    var body: some View {
        HStack {
            deadlineButtonView
            
            tagPickerView
            
            matrixButtonView
            
            Spacer()
            
            enterButtonView
        }
        .padding(.bottom, 20)
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray10.ignoresSafeArea(.all))
    }
    
    var deadlineButtonView: some View {
        Button(action: {
            viewModel.isEndDatePickerPresented = true
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
        .cornerRadius(2)
        .sheet(isPresented: $viewModel.isEndDatePickerPresented) {
            PickerSheet(type: .addToDo(.date)) {
                VStack {
                    SheetOKButton { viewModel.isEndDatePickerPresented = false }
                    
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
    
    private var tagPickerView: some View {
        Button(action: {
            if viewModel.tagList.isEmpty {
                viewModel.getTags()
            }
            viewModel.isTagPickerPresented = true
        }) {
            Circle()
                .fill(Color(viewModel.selectedTag.color))
                .frame(width: 10, height: 10)
        }
        .frame(width: 42, height: 42)
        .background(Color.gray09)
        .cornerRadius(2)
        .sheet(isPresented: $viewModel.isTagPickerPresented) {
            TagPickerSheet(
                viewModel: viewModel,
                isPresented: $viewModel.isTagPickerPresented,
                type: .addToDo(.tag),
                tagList: viewModel.tagList
            )
        }
    }
    
    private var matrixButtonView: some View {
        Button(action: {
            viewModel.isPriorityPickerPresented = true
        }) {
            Image(viewModel.selectedPriority.imageName)
                .frame(width: 26, height: 26)
                .padding(8)
                .background(Color.gray09)
                .cornerRadius(2)
        }
        .frame(width: 42, height: 42)
        .sheet(isPresented: $viewModel.isPriorityPickerPresented) {
            PickerSheet(type: .addToDo(.priority)) {
                AddToDoPrioritySheet(
                    viewModel: viewModel,
                    viewType: .add
                )
            }
        }
    }
    
    private var enterButtonView: some View {
        Button(action: {
            viewModel.postToDo {
                withAnimation(.spring()) {
                    isAddViewPresented = false
                }
            }
        }) {
            Image(viewModel.isTextEmpty ? .btn_enter_disabled : .btn_enter_active)
        }
        .disabled(viewModel.isTextEmpty)
    }
}
