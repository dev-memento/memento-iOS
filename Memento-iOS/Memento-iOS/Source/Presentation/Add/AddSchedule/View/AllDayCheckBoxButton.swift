//
//  AllDayCheckBoxButton.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AllDayCheckBoxButton: View {

    // MARK: - Properties

    @ObservedObject var viewModel: PickerButtonViewModel

    // MARK: - Body

    var body: some View {
        HStack {
            Spacer()
            Button(action: toggleAllDay) {
                HStack {
                    Image(
                        viewModel.isAllDay
                        ? .btn_check_selected_square
                        : .btn_check_unselected_square)
                    Text("All-day")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                }
            }
            .padding(.top, 12)
        }
    }

    // MARK: - Helpers

    private func toggleAllDay() {
        viewModel.isAllDay.toggle()
    }
}
