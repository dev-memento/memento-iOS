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

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddScheduleViewModel = .init()

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()

            VStack {
                toggleSection
                titleInputSection
                dateTimePickerSection(type: .start)
                dateTimePickerSection(type: .end)
                allDayCheckBoxSection
                tagPickerSection
                Spacer()
                enterButton
            }
            .padding(.horizontal)
        }
    }

    // MARK: - UI Components

    private var toggleSection: some View {
        CustomToggleView(isOn: $viewModel.isNaturalLanguageInputEnabled)
    }

    private var titleInputSection: some View {
        VStack {
            ZStack(alignment: .leading) {
                if viewModel.isTitleEmpty {
                    Text(StringLiteral.AddEvent.title)
                        .foregroundColor(.gray07)
                        .applyFont(.body_b_18)
                }

                TextField("", text: $viewModel.title)
                    .tint(Color.mementoLightGreen)
                    .foregroundColor(.grayWhite)
                    .applyFont(.body_b_18)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            }
            .frame(height: 24)
            .padding(.vertical, 8)

            Divider()
                .frame(height: 2)
                .background(Color.gray08)
                .padding(.bottom, 24)
        }
    }

    private func dateTimePickerSection(type: AddScheduleSectionType) -> some View {
        let title = (type == .start) ? StringLiteral.Common.starts : StringLiteral.Common.ends
        let formattedDate = (type == .start) ? viewModel.formattedStartDate : viewModel.formattedEndDate
        let formattedTime = (type == .start) ? viewModel.formattedStartTime : viewModel.formattedEndTime
        let dateBinding = (type == .start) ? $viewModel.startDate : $viewModel.endDate
        let timeBinding = (type == .start) ? $viewModel.startTime : $viewModel.endTime
        let isDatePresented = (type == .start) ? $viewModel.isStartDatePressed : $viewModel.isEndDatePressed
        let isTimePresented = (type == .start) ? $viewModel.isStartTimePressed : $viewModel.isEndTimePressed

        return HStack {
            Text(title)
                .applyFont(.body_r_16)
                .foregroundColor(.gray05)

            Spacer()

            Button {
                viewModel.presentDatePicker(type: type)
            } label: {
                Text(formattedDate)
                    .applyFont(.body_r_14)
                    .foregroundColor(.gray02)
                    .frame(width: 124, height: 36)
                    .background(isDatePresented.wrappedValue ? Color.gray07 : Color.gray09)
                    .cornerRadius(2)
            }
            .sheet(isPresented: isDatePresented) {
                SheetContainer(type: .addSchedule(.date)) {
                    VStack {
                        SheetOKButton { viewModel.dismissDatePicker(type: type) }

                        DatePicker(
                            "",
                            selection: dateBinding,
                            displayedComponents: .date
                        )
                        .colorScheme(.dark)
                        .datePickerStyle(.graphical)
                        .tint(.mementoBlue)
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }

            Button {
                viewModel.presentTimePicker(type: type)
            } label: {
                Text(formattedTime)
                    .applyFont(.body_r_14)
                    .foregroundColor(.gray02)
                    .frame(width: 96, height: 36)
                    .background(isTimePresented.wrappedValue ? Color.gray07 : Color.gray09)
                    .cornerRadius(2)
            }
            .disabled(viewModel.isAllDay)
            .opacity(viewModel.isAllDay ? 0.3 : 1.0)
            .sheet(isPresented: isTimePresented) {
                SheetContainer(type: .addSchedule(.time)) {
                    VStack {
                        SheetOKButton { viewModel.dismissTimePicker(type: type) }

                        DatePicker(
                            "",
                            selection: timeBinding,
                            displayedComponents: .hourAndMinute
                        )
                        .colorScheme(.dark)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                        .tint(.mementoBlue)
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }
        }
    }

    private var allDayCheckBoxSection: some View {
        HStack {
            Spacer()

            let isEnabled = viewModel.isEventLongerThan24Hours()

            Button(action: viewModel.toggleAllDay) {
                HStack {
                    Image(viewModel.isAllDay ? .btn_check_selected_square : .btn_check_unselected_square)
                        .renderingMode(.template)
                        .foregroundColor(isEnabled ? .gray05 : .gray07)
                        .opacity(isEnabled ? 1.0 : 0.5)

                    Text(StringLiteral.AddSchedule.allDay)
                        .applyFont(.body_r_14)
                        .foregroundColor(isEnabled ? .gray05 : .gray07)
                        .opacity(isEnabled ? 1.0 : 0.5)
                }
            }
            .disabled(!isEnabled)
            .padding(.top, 12)
        }
    }

    private var tagPickerSection: some View {
        HStack {
            Text(StringLiteral.Common.tag)
                .applyFont(.body_r_16)
                .foregroundStyle(Color.gray05)

            Spacer()

            Button(action: viewModel.presentTagPicker) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(viewModel.selectedTag.color)
                        .frame(width: 14, height: 14)

                    Text(viewModel.selectedTag.title)
                        .applyFont(.body_r_14)
                        .foregroundColor(.gray02)
                }
                .frame(width: 200, height: 36)
                .background(viewModel.isTagPressed ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
            }
            .sheet(isPresented: $viewModel.isTagPressed) {
                TagPickerSheet(
                    viewModel: viewModel,
                    isPresented: $viewModel.isTagPressed,
                    type: .addSchedule(.tag)
                )
            }
        }
    }

    private var enterButton: some View {
        HStack {
            Spacer()

            Button {
                viewModel.postAddSchedule { dismiss() }
            } label: {
                Image( viewModel.isTitleEmpty ? .btn_enter_disabled : .btn_enter_active)
            }
            .padding(.trailing)
            .padding(.bottom, 40)
            .disabled(viewModel.isTitleEmpty)
        }
    }
}
