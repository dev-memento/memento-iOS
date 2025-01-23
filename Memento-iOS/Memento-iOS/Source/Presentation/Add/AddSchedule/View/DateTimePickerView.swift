//
//  DateTimePickerView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct DateTimePickerView: View {

    // MARK: - Properties

    @StateObject private var viewModel: AddSchedulePickerButtonViewModel

    // MARK: - Initializer

    init(viewModel: AddSchedulePickerButtonViewModel = AddSchedulePickerButtonViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        VStack {
            DateTimePickerSectionView(
                title: "Starts",
                viewModel: viewModel,
                sectionType: .start
            )

            DateTimePickerSectionView(
                title: "Ends",
                viewModel: viewModel,
                sectionType: .end
            )

            AllDayCheckBoxButton(viewModel: viewModel)
        }
    }
}

// MARK: - Preview

#Preview {
    DateTimePickerView()
}
