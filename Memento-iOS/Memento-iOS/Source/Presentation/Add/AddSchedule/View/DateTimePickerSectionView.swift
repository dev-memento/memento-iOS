//
//  DateTimePickerSectionView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct DateTimePickerSectionView: View {

    // MARK: - Properties

    let title: String
    @ObservedObject var viewModel: PickerButtonViewModel
    let sectionType: AddScheduleSectionType

    @StateObject private var datePickerViewModel = PickerButtonViewModel()
    @StateObject private var timePickerViewModel = PickerButtonViewModel()

    // MARK: - Body

    var body: some View {
        HStack {
            Text(title)
                .applyFont(.body_r_16)
                .foregroundColor(.gray05)

            Spacer()

            datePickerButton
            timePickerButton
        }
    }

    // MARK: - UI Components

    private var datePickerButton: some View {
        PickerButton(
            type: .date,
            title: formattedDate,
            width: 124,
            action: { datePickerViewModel.togglePresentation() },
            viewModel: datePickerViewModel
        )
        .sheet(
            isPresented: $datePickerViewModel.isPresented,
            onDismiss: { datePickerViewModel.dismiss() }
        ) {
            BaseSheetView(
                selection: sectionType == .start ? $viewModel.startsDate : $viewModel.endsDate,
                isPresented: $datePickerViewModel.isPresented,
                type: .date,
                isStartsDate: sectionType == .start,
                minimumDate: sectionType == .end ? viewModel.startsDate : nil
            )
        }
    }

    private var timePickerButton: some View {
        PickerButton(
            type: .time,
            title: formattedTime,
            width: 96,
            action: { timePickerViewModel.togglePresentation() },
            viewModel: timePickerViewModel
        )
        .disabled(viewModel.isAllDay)
        .opacity(viewModel.isAllDay ? 0.3 : 1.0)
        .sheet(
            isPresented: $timePickerViewModel.isPresented,
            onDismiss: { timePickerViewModel.dismiss() }
        ) {
            BaseSheetView(
                selection: sectionType == .start ? $viewModel.selectedStartTime : $viewModel.selectedEndTime,
                isPresented: $timePickerViewModel.isPresented,
                type: .time,
                onDismiss: viewModel.dismiss
            )
        }
    }

    // MARK: - Helpers

    private var formattedDate: String {
        let date =
        sectionType == .start
        ? viewModel.startsDate
        : viewModel.endsDate

        return date.formattedDate(with: "MMM d, yyyy")
    }

    private var formattedTime: String {
        sectionType == .start
        ? viewModel.formattedStartTime
        : viewModel.formattedEndTime
    }
}
