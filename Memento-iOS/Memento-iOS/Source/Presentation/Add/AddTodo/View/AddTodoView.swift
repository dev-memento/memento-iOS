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
        }
        .padding(.horizontal)
        .background(Color.gray10)
        .onAppear {
            loadTokens()
            todoViewModel.startDate = headerViewModel.isoFormattedDate
            todoViewModel.endDate = bottomViewModel.isoFormattedDate
        }
    }

    private func loadTokens() {
        do {
            if let accessToken = try TokenKeychainManager.shared.loadAccessToken() {
                print("Access Token: \(accessToken)")
            } else {
                print("Access Token이 저장되지 않았습니다.")
            }

            if let refreshToken = try TokenKeychainManager.shared.loadRefreshToken() {
                print("Refresh Token: \(refreshToken)")
            } else {
                print("Refresh Token이 저장되지 않았습니다.")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
