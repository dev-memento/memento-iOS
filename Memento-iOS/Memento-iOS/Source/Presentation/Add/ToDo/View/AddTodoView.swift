//
//  AddToDoView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddToDoView: View {
    
    @StateObject private var viewModel = AddToDoViewModel()
    
    var body: some View {
        VStack(spacing: 13) {
            HStack(spacing: 0) {
                Text(StringLiteral.AddToDo.title)
                    .foregroundColor(.gray07)
                    .applyFont(.body_r_14)
                
                Button(viewModel.formattedStartDate) {
                    viewModel.isStartDatePickerPresented = true
                }
                .foregroundColor(.gray04)
                .applyFont(.body_r_14)
                .sheet(isPresented: $viewModel.isStartDatePickerPresented) {
                    PickerSheet(type: .addToDo(.date)) {
                        SheetOKButton { viewModel.isStartDatePickerPresented = false }
                        
                        DatePicker(
                            "",
                            selection: $viewModel.startDate,
                            displayedComponents: .date
                        )
                        .colorScheme(.dark)
                        .datePickerStyle(.graphical)
                        .tint(.mementoBlue)
                        .padding([.horizontal, .bottom], 10)
                    }
                }
                
                Spacer()
                
                CustomToggleView(isOn: $viewModel.isNaturalLanguageEnabled)
            }
            
            AddTodoTextView(viewModel: viewModel)
        }
        .padding(.horizontal, 23)
        .background(Color.gray10)
    }
}
