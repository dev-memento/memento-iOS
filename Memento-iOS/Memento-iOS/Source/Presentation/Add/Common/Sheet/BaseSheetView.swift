//
//  BaseSheetView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct BaseSheetView: View {

    @Binding var selection: Date
    @Binding var isPresented: Bool
    let type: PickerButtonType
    var isStartsDate: Bool = false
    var minimumDate: Date? = nil
    var onDismiss: (() -> Void)? = nil
    var tagViewModel: PickerButtonViewModel? = nil

    private var dateRange: ClosedRange<Date> {
        if isStartsDate {
            return Calendar.current.startOfDay(for: Date())...Date.distantFuture
        } else {
            return (minimumDate ?? .distantPast)...Date.distantFuture
        }
    }

    var body: some View {
        SheetContainer(type: type) {
            VStack(spacing: 0) {
                SheetHeaderView {
                    switch type {
                    case .time:
                        let calendar = Calendar.current
                        let hour = calendar.component(.hour, from: selection)
                        let minute = calendar.component(.minute, from: selection)

                        if let newDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: selection) {
                            selection = newDate
                        }
                    case .tag:
                        isPresented = true
                    default:
                        break
                    }
                    onDismiss?()
                    isPresented = false
                }

                switch type {
                case .date:
                    DatePicker(
                        "날짜 선택",
                        selection: $selection,
                        in: dateRange,
                        displayedComponents: .date
                    )
                    .colorScheme(.dark)
                    .datePickerStyle(.graphical)
                    .frame(width: 320)
                    .transition(.move(edge: .bottom))
                    .tint(.mementoBlue)

                case .time:
                    DatePicker(
                        "",
                        selection: $selection,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .colorScheme(.dark)
                    .datePickerStyle(.wheel)
                    .environment(\.locale, Locale(identifier: "en_US"))

                case .tag, .deadline: EmptyView()
                }
            }
        }
    }
}
