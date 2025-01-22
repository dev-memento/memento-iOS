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

    // MARK: - Body

    var body: some View {
        VStack {
            AddTodoHeaderView(viewModel: headerViewModel)
            AddTodoTextView(viewModel: textViewModel)

            Spacer()

            AddTodoBottomView(viewModel: textViewModel)
        }
        .padding(.horizontal)
        .background(Color.gray10)
    }
}

#Preview {
    AddTodoView()
}
