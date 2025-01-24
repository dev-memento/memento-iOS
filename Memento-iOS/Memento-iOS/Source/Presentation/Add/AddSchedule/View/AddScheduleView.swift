//
//  AddScheduleView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddScheduleView: View {
    @Environment(\.dismiss) var dismiss
    // MARK: - Properties
    @StateObject private var addScheduleViewModel: AddScheduleViewModel = .init(scheduleApiService: .init())
    @StateObject private var eventTitleViewModel: AddEventTitleViewModel = .init()
    @StateObject private var pickerViewModel: AddSchedulePickerButtonViewModel = .init()

    // MARK: - Body
    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()
            VStack {
                AddEventTitleView(viewModel: eventTitleViewModel)
                DateTimePickerView(viewModel: pickerViewModel)
                TagView(viewModel: pickerViewModel)
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
                addScheduleViewModel.postAddSchedule(description: eventTitleViewModel.title,
                                                     startDate: pickerViewModel.startsDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
                                                     endDate: pickerViewModel.endsDate.formattedDate(with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
                                                     isAllDay: pickerViewModel.isAllDay,
                                                     tagID: pickerViewModel.selectedTag.tagId) {
                    dismiss()
                }
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

