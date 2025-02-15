//
//  AddTodoHeaderView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddTodoHeaderView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: AddTodoViewModel

    // MARK: - Body
    
    var body: some View {
        HStack {
            Text("Add to-do,")
                .foregroundColor(.gray07)
                .applyFont(.body_b_18)
            
            Button(viewModel.formattedStartDate) {
                viewModel.showStartDatePicker = true
            }
            .foregroundColor(.gray04)
            .applyFont(.body_b_18)
            .sheet(isPresented: $viewModel.showStartDatePicker) {
                SheetContainer(type: .addTodo(.date)) {
                    VStack {
                        SheetHeaderView {
                            viewModel.showStartDatePicker = false
                        }
                        
                        DatePicker(
                            "",
                            selection: $viewModel.startDate,
                            displayedComponents: .date
                        )
                        .colorScheme(.dark)
                        .datePickerStyle(.graphical)
                        .transition(.move(edge: .bottom))
                        .tint(.mementoBlue)
                    }
                }
            }
            
            Spacer()
        }
    }
}
