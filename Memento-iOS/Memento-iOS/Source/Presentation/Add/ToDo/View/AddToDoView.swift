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
    
    @Binding var isAddViewPresented: Bool
    
    var body: some View {
        VStack(spacing: 13) {
            HStack(spacing: 0) {
                Text(StringLiteral.AddToDo.title)
                    .foregroundColor(.gray07)
                    .applyFont(.body_r_14)
                    .padding(.trailing, 5)
                
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
            
            AddToDoTextView(viewModel: viewModel, isAddViewPresented: $isAddViewPresented)
        }
        .padding(.leading, 23)
        .padding(.trailing, 16)
        .background(Color.gray10)
    }
}
