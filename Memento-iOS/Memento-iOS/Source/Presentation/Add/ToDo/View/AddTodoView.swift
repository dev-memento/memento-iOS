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
    
    @StateObject private var viewModel = AddToDoViewModel()
    @EnvironmentObject var todolistViewModel: ToDoListViewModel
    var onClose: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            AddTodoHeaderView(viewModel: viewModel)
            AddTodoTextView(viewModel: viewModel, onClose: onClose)
        }
        .padding(.horizontal)
        .background(Color.gray10)
    }
}
