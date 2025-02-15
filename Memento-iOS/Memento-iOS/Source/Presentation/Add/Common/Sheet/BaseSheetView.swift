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
    let type: AddSchedulePickerButtonType
    var isStartsDate: Bool = false
    var minimumDate: Date? = nil
    var onDismiss: (() -> Void)? = nil
    var tagViewModel: AddSchedulePickerButtonViewModel? = nil

    private var dateRange: ClosedRange<Date> {
        if isStartsDate {
            return Calendar.current.startOfDay(for: Date())...Date.distantFuture
        } else {
            return (minimumDate ?? .distantPast)...Date.distantFuture
        }
    }

    var body: some View {
        // TODO: 다음 리팩토링 대상
        EmptyView()
    }
}
