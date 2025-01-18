//
//  AddScheduleView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddScheduleView: View {

    // MARK: - Properties

    @StateObject private var eventTitleViewModel = AddEventTitleViewModel()
    @StateObject private var pickerViewModel = PickerButtonViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()

            VStack {
                AddEventTitleView(viewModel: eventTitleViewModel)
                DateTimePickerView(viewModel: pickerViewModel)
                RepeatPickerView(viewModel: pickerViewModel)
                TagView()
                Spacer()
                enterButton
            }
            .padding(.horizontal)
        }
    }

    // MARK: - UI Components

    private var enterButton: some View {
        HStack {
            Spacer()
            Button(action: {
            }) {
                Image(
                    eventTitleViewModel.isTitleEmpty
                    ? .btn_enter_disabled
                    : .btn_enter_active
                )
            }
            .frame(width: 42, height: 42)
            .clipShape(Circle())
            .disabled(eventTitleViewModel.isTitleEmpty)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - Preview

#Preview {
    AddScheduleView()
}
