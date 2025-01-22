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

    @ObservedObject var viewModel: AddTodoHeaderViewModel

    // MARK: - Body

    var body: some View {
        HStack {
            Text("Add to-do,")
                .foregroundColor(.gray07)
                .applyFont(.body_b_18)

            Button(viewModel.formattedDate) {
                viewModel.showDatePicker = true
            }
            .foregroundColor(.gray04)
            .applyFont(.body_b_18)
            .sheet(isPresented: $viewModel.showDatePicker) {
                SheetContainer(type: .date) {
                    VStack {
                        SheetHeaderView {
                            viewModel.showDatePicker = false
                        }

                        DatePicker(
                            "",
                            selection: $viewModel.selectedDate,
                            displayedComponents: .date
                        )
                        .colorScheme(.dark)
                        .datePickerStyle(.graphical)
                        .frame(width: 320)
                        .transition(.move(edge: .bottom))
                        .tint(.mementoBlue)
                    }
                }
            }

            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    AddTodoHeaderView(viewModel: AddTodoHeaderViewModel())
}
