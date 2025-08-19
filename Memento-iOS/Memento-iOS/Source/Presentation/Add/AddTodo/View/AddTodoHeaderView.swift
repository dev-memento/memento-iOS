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
            Text(StringLiteral.AddTodo.title)
                .foregroundColor(.gray07)
                .applyFont(.body_r_14)

            Button(viewModel.formattedStartDate) {
                viewModel.showStartDatePicker = true
            }
            .foregroundColor(.gray04)
            .applyFont(.body_r_14)
            .sheet(isPresented: $viewModel.showStartDatePicker) {
                SheetContainer(type: .addToDo(.date)) {
                    SheetOKButton { viewModel.showStartDatePicker = false }

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

            CustomToggleView(isOn: $viewModel.isNaturalLanguageInputEnabled)
        }
    }
}
