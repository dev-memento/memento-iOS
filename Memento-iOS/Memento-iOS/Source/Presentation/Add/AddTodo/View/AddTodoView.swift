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

    @ObservedObject var segmentedViewModel: SegmentedMenuViewModel

    @StateObject private var viewModel = AddTodoViewModel()

    // MARK: - Body

    var body: some View {
        VStack {
            AddTodoHeaderView(viewModel: viewModel)
            AddTodoTextView(viewModel: viewModel, segmentedViewModel: segmentedViewModel)
        }
        .padding(.horizontal)
        .background(Color.gray10)
    }
}
