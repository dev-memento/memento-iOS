//
//  EditScheduleView.swift
//  Memento-iOS
//
//  Created by 이세민 on 9/7/25.
//

import SwiftUI
import Combine
import MDSKit

struct EditScheduleView: View {
    
    @StateObject private var viewModel: EditScheduleViewModel
    
    @Binding var isEditViewPresented: Bool
    
    @State private var isStartDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    @State private var isStartTimePickerPresented = false
    @State private var isEndTimePickerPresented = false
    @State private var isTagPickerPresented = false
    
    @GestureState private var translation: CGFloat = .zero
    @State private var sheetHeight: CGFloat = .zero
    
    init(isEditViewPresented: Binding<Bool>, scheduleItem: ScheduleItem) {
        self._isEditViewPresented = isEditViewPresented
        _viewModel = StateObject(wrappedValue: EditScheduleViewModel(scheduleItem: scheduleItem))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let calculatedSheetHeight = geometry.size.height * 0.8
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        Button { isEditViewPresented = false } label: {
                            Text("Cancel")
                                .applyFont(.body_r_16)
                                .foregroundStyle(Color.red)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        
                        Spacer()
                        
                        Button {
                            viewModel.updateSchedule {
                                isEditViewPresented = false
                            }
                        } label: {
                            Text("Done")
                                .applyFont(.body_r_16)
                                .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                    }
                    .padding(.vertical, 6)
                    
                    VStack {
                        ZStack(alignment: .leading) {
                            if viewModel.description.isEmpty {
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
                        
                        // MARK: - Date & Allday
                        
                        dateTimePickerView(type: .start)
                        dateTimePickerView(type: .end)
                        
                        HStack {
                            Spacer()
                            
                            Button() {
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
                        
                        // MARK: - Tag
                        
                        HStack {
                            Text(StringLiteral.Common.tag)
                                .applyFont(.body_r_16)
                                .foregroundStyle(Color.gray05)
                            
                            Spacer()
                            
                            Button(action: {
                                isTagPickerPresented = true
                            }) {
                                HStack(spacing: 5) {
                                    Image(.ic_tag)
                                        .renderingMode(.template)
                                        .foregroundColor(Color.fromHex(viewModel.tagColorCode))
                                    
                                    Text(viewModel.tagName)
                                        .applyFont(.body_r_14)
                                        .foregroundColor(.gray02)
                                }
                                .frame(width: 200, height: 36)
                                .background(isTagPickerPresented ? Color.gray07 : Color.gray09)
                                .cornerRadius(2)
                            }
                            .sheet(isPresented: $isTagPickerPresented) {
                                PickerSheet(type: .addSchedule(.tag)) {
                                    SheetOKButton { isTagPickerPresented = false }
                                    List {
                                        ForEach(viewModel.tagList) { tag in
                                            Button(action: {
                                                viewModel.tagName = tag.name
                                                viewModel.tagColorCode = tag.color.toHex()
                                            }) {
                                                HStack {
                                                    Circle()
                                                        .fill(tag.color)
                                                        .frame(width: 12, height: 12)
                                                    Text(tag.name)
                                                        .applyFont(.body_r_14)
                                                        .foregroundStyle(viewModel.tagName == tag.name ? Color.gray02 : Color.gray07)
                                                    Spacer()
                                                }
                                            }
                                            .listRowBackground(viewModel.tagName == tag.name ? Color.gray08 : Color.clear)
                                        }
                                    }
                                    .listStyle(PlainListStyle())
                                    .ignoresSafeArea()
                                    .padding([.horizontal, .bottom], 10)
                                    .scrollDisabled(viewModel.tagList.count <= 3)
                                }
                                .applyDynamicSheetForTagCount(tagCount: viewModel.tagList.count)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(height: calculatedSheetHeight)
                .background(Color.gray10)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            if value.translation.height > 0 {
                                state = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > calculatedSheetHeight / 3 {
                                isEditViewPresented = false
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .onAppear {
                sheetHeight = calculatedSheetHeight
            }
            .background(Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { isEditViewPresented = false })
            .transition(.move(edge: .bottom))
            .animation(.spring, value: isEditViewPresented)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func dateTimePickerView(type: DateTimeType) -> some View {
        let title = (type == .start) ? StringLiteral.Common.starts : StringLiteral.Common.ends
        
        let dateBinding = (type == .start) ? $viewModel.startDate : $viewModel.endDate
        let date = Date.dateFromString(dateBinding.wrappedValue, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        ?? Date.dateFromString(dateBinding.wrappedValue, format: "yyyy-MM-dd'T'HH:mm:ss")
        ?? Date()
        
        let isDatePickerPresented = (type == .start) ? $isStartDatePickerPresented : $isEndDatePickerPresented
        let isTimePickerPresented = (type == .start) ? $isStartTimePickerPresented : $isEndTimePickerPresented
        
        return HStack(spacing: 0) {
            Text(title)
                .applyFont(.body_r_16)
                .foregroundColor(.gray05)
            
            Spacer()
            
            HStack(spacing: 10) {
                PickerButton(
                    label: date.stringFromDate(with: "MMM d, yyyy"),
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
                                selection: Binding(
                                    get: { date },
                                    set: { newValue in
                                        dateBinding.wrappedValue = newValue.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
                                    }
                                ),
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
                    label: date.stringFromDate(with: "h:mm a"),
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
                                selection: Binding(
                                    get: { date },
                                    set: { newValue in
                                        dateBinding.wrappedValue = newValue.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
                                    }
                                ),
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
}
