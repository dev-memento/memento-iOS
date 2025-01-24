//
//  AddTodoView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddTodoView: View {

    // MARK: - Properties

    @StateObject private var headerViewModel = AddTodoHeaderViewModel()
    @StateObject private var textViewModel = AddTodoTextViewModel()
    @StateObject private var bottomViewModel = AddTodoPickerButtonViewModel(type: .deadline)
    @StateObject private var todoViewModel = AddTodoViewModel()

    // MARK: - Body

    var body: some View {
        VStack {
            AddTodoHeaderView(viewModel: headerViewModel)
                .onAppear {
                    todoViewModel.startDate = headerViewModel.isoFormattedDate
                }

            AddTodoTextView(viewModel: textViewModel)

            Spacer()

            AddTodoBottomView(
                viewModel: textViewModel,
                todoViewModel: todoViewModel,
                bottomViewModel: bottomViewModel
            )
            .onChange(of: bottomViewModel.selectedDate) {
                todoViewModel.endDate = bottomViewModel.isoFormattedDate
            }
            .onChange(of: todoViewModel.selectedPriority) { _, newValue in
                let (urgency, importance) = newValue.getPriorityValues()
                todoViewModel.priorityUrgency = urgency
                todoViewModel.priorityImportance = importance
            }
        }
        .padding(.horizontal)
        .background(Color.gray10)
        .onAppear {
            todoViewModel.startDate = headerViewModel.isoFormattedDate
            todoViewModel.endDate = bottomViewModel.isoFormattedDate
        }
    }
}
