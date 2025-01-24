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
            AddTodoTextView(viewModel: textViewModel)

            Spacer()

            AddTodoBottomView(
                viewModel: textViewModel,
                todoViewModel: todoViewModel,
                bottomViewModel: bottomViewModel
            )
            .onChange(of: todoViewModel.selectedPriority) { _, newValue in
                let (urgency, importance) = newValue.getPriorityValues()
                todoViewModel.priorityUrgency = urgency
                todoViewModel.priorityImportance = importance
            }
        }
        .padding(.horizontal)
        .background(Color.gray10)
        .onChange(of: headerViewModel.selectedDate) {
            if headerViewModel.selectedDate != bottomViewModel.selectedDate {
                bottomViewModel.selectedDate = headerViewModel.selectedDate
            }
            todoViewModel.startDate = headerViewModel.selectedDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            todoViewModel.endDate = headerViewModel.selectedDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        }
        .onChange(of: bottomViewModel.selectedDate) {
            if headerViewModel.selectedDate != bottomViewModel.selectedDate {
                headerViewModel.selectedDate = bottomViewModel.selectedDate
            }
            todoViewModel.startDate = headerViewModel.selectedDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            todoViewModel.endDate = headerViewModel.selectedDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        }
    }
}
