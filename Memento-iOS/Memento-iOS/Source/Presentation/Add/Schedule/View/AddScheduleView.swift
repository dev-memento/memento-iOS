//
//  AddScheduleView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddScheduleView: View {
    
    @StateObject private var viewModel: AddScheduleViewModel = .init()
    
    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()
            
            VStack {
                CustomToggleView(isOn: $viewModel.isNaturalLanguageEnabled)
                
                titleInputView
                
                dateTimePickerView(type: .start)
                dateTimePickerView(type: .end)
                
                allDayCheckBoxView
                
                tagPickerView
                
                Spacer()
                
                enterButtonView
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.getTagsAPI()
        }
    }
    
    private var titleInputView: some View {
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
                .padding(.bottom, 31)
        }
    }
    
    private func dateTimePickerView(type: DateTimeType) -> some View {
        let title = (type == .start) ? StringLiteral.Common.starts : StringLiteral.Common.ends
        let formattedDate = (type == .start) ? viewModel.formattedStartDate : viewModel.formattedEndDate
        let formattedTime = (type == .start) ? viewModel.formattedStartTime : viewModel.formattedEndTime
        let selectedDate = (type == .start) ? $viewModel.startDate : $viewModel.endDate
        let selectedTime = (type == .start) ? $viewModel.startTime : $viewModel.endTime
        let isDatePickerPresented = (type == .start) ? $viewModel.isStartDatePickerPresented : $viewModel.isEndDatePickerPresented
        let isTimePickerPresented = (type == .start) ? $viewModel.isStartTimePickerPresented : $viewModel.isEndTimePickerPresented
        
        return HStack(spacing: 0) {
            Text(title)
                .applyFont(.body_r_16)
                .foregroundColor(.gray05)
            
            Spacer()
            
            HStack(spacing: 10) {
                PickerButton(
                    label: formattedDate,
                    isPresented: isDatePickerPresented,
                    onTap: { viewModel.presentDatePicker(type: type) }
                )
                .sheet(isPresented: isDatePickerPresented) {
                    SheetContainer(type: .addSchedule(.date)) {
                        VStack {
                            SheetOKButton { viewModel.dismissDatePicker(type: type) }
                            
                            DatePicker(
                                "",
                                selection: selectedDate,
                                displayedComponents: .date
                            )
                            .colorScheme(.dark)
                            .datePickerStyle(.graphical)
                            .tint(.mementoBlue)
                            .padding([.horizontal, .bottom], 10)
                        }
                    }
                }
                
                PickerButton(
                    label: formattedTime,
                    isPresented: isTimePickerPresented,
                    onTap: { viewModel.presentTimePicker(type: type) }
                )
                .disabled(viewModel.isAllDay)
                .opacity(viewModel.isAllDay ? 0.3 : 1.0)
                .sheet(isPresented: isTimePickerPresented) {
                    SheetContainer(type: .addSchedule(.time)) {
                        VStack {
                            SheetOKButton { viewModel.dismissTimePicker(type: type) }
                            
                            DatePicker(
                                "",
                                selection: selectedTime,
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
    }
    
    private var allDayCheckBoxView: some View {
        HStack {
            Spacer()
            
            Button(action: viewModel.toggleAllDay) {
                HStack(spacing: 10) {
                    Image(viewModel.isAllDay ? .btn_check_selected_square : .btn_check_unselected_square)
                        .renderingMode(.template)
                        .foregroundColor(viewModel.isOverOneDay() ? .gray05 : .gray07)
                        .opacity(viewModel.isOverOneDay() ? 1.0 : 0.5)
                    
                    Text(StringLiteral.AddSchedule.allDay)
                        .applyFont(.body_r_14)
                        .foregroundColor(viewModel.isOverOneDay() ? .gray05 : .gray07)
                        .opacity(viewModel.isOverOneDay() ? 1.0 : 0.5)
                }
            }
            .disabled(!viewModel.isOverOneDay())
            .padding(.trailing, 11)
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
    }
    
    private var tagPickerView: some View {
        HStack {
            Text(StringLiteral.Common.tag)
                .applyFont(.body_r_16)
                .foregroundStyle(Color.gray05)
            
            Spacer()
            
            Button(action: viewModel.presentTagPicker) {
                HStack(spacing: 5) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(viewModel.selectedTag.color)
                    
                    Text(viewModel.selectedTag.name)
                        .applyFont(.body_r_14)
                        .foregroundColor(.gray02)
                }
                .frame(width: 200, height: 36)
                .background(viewModel.isTagPickerPresented ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
            }
            .sheet(isPresented: $viewModel.isTagPickerPresented) {
                TagPickerSheet(
                    viewModel: viewModel,
                    isPresented: $viewModel.isTagPickerPresented,
                    type: .addSchedule(.tag),
                    tagList: viewModel.tagList
                )
            }
        }
    }
    
    private var enterButtonView: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.postAddSchedule { }
            } label: {
                Image( viewModel.isTitleEmpty ? .btn_enter_disabled : .btn_enter_active)
            }
            .padding(.trailing, 10)
            .padding(.bottom, 40)
            .disabled(viewModel.isTitleEmpty)
        }
    }
}
