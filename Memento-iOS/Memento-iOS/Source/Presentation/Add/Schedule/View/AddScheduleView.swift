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
    
    @Binding var isAddViewPresented: Bool
    
    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    @State private var isStartTimePickerPresented = false
    @State private var isEndTimePickerPresented = false
    @State private var isTagPickerPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
            VStack {
                CustomToggleView(isOn: $viewModel.isNaturalLanguageEnabled)
                
                descriptionInputView
                
                dateTimePickerView(type: .start)
                dateTimePickerView(type: .end)
                
                allDayCheckBoxView
                
                tagPickerView
                
                Spacer()
                
                enterButtonView
            }
            .padding(.horizontal)
        }
    }
    
    private var descriptionInputView: some View {
        VStack {
            ZStack(alignment: .leading) {
                if viewModel.isTextEmpty {
                    Text(StringLiteral.AddEvent.title)
                        .foregroundColor(.gray07)
                        .applyFont(.body_b_18)
                }
                
                TextField("", text: $viewModel.description)
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
        
        let isDatePickerPresented = (type == .start) ? $isStartDatePickerPresented : $isEndDatePickerPresented
        let isTimePickerPresented = (type == .start) ? $isStartTimePickerPresented : $isEndTimePickerPresented
        
        return HStack(spacing: 0) {
            Text(title)
                .applyFont(.body_r_16)
                .foregroundColor(.gray05)
            
            Spacer()
            
            HStack(spacing: 10) {
                PickerButton(
                    label: formattedDate,
                    isPresented: isDatePickerPresented,
                    onTap: { isDatePickerPresented.wrappedValue.toggle() },
                    width: 124
                )
                .sheet(isPresented: isDatePickerPresented) {
                    PickerSheet(type: .addSchedule(.date(type))) {
                        VStack {
                            SheetOKButton { isDatePickerPresented.wrappedValue = false }
                            
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
                    onTap: { if !viewModel.isAllDay { isTimePickerPresented.wrappedValue.toggle() } },
                    width: 96
                )
                .disabled(viewModel.isAllDay)
                .opacity(viewModel.isAllDay ? 0.3 : 1.0)
                .sheet(isPresented: isTimePickerPresented) {
                    PickerSheet(type: .addSchedule(.time(type))) {
                        VStack {
                            SheetOKButton { isTimePickerPresented.wrappedValue = false }
                            
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
            
            Button(action: {
                viewModel.isAllDay.toggle()
            }) {
                HStack(spacing: 10) {
                    Image(viewModel.isAllDay ? .btn_check_selected_square : .btn_check_unselected_square)
                        .renderingMode(.template)
                        .foregroundColor(.gray05)
                    
                    Text(StringLiteral.AddSchedule.allDay)
                        .applyFont(.body_r_14)
                        .foregroundColor(.gray05)
                }
            }
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
            
            Button(action: {
                if viewModel.tagList.isEmpty {
                    viewModel.getTags()
                }
                isTagPickerPresented = true
            }) {
                HStack(spacing: 5) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(viewModel.selectedTag.color)
                    
                    Text(viewModel.selectedTag.name)
                        .applyFont(.body_r_14)
                        .foregroundColor(.gray02)
                }
                .frame(width: 200, height: 36)
                .background(isTagPickerPresented ? Color.gray07 : Color.gray09)
                .cornerRadius(2)
            }
            .sheet(isPresented: $isTagPickerPresented) {
                TagPickerSheet(
                    viewModel: viewModel,
                    isPresented: $isTagPickerPresented,
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
                viewModel.postSchedule {
                    withAnimation(.spring()) {
                        isAddViewPresented = false
                    }
                }
            } label: {
                Image( viewModel.isTextEmpty ? .btn_enter_disabled : .btn_enter_active)
            }
            .padding(.trailing, 10)
            .padding(.bottom, 40)
            .disabled(viewModel.isTextEmpty)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
