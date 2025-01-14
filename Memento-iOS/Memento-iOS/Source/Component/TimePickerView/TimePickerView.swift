//
//  TimePickerView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/11/25.
//

import SwiftUI

/// 선택 가능한 시간 유형
enum TimeType {
    case wakeUp
    case windDown
}

struct TimePickerView: View {
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: TimeType
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()

                // DatePicker
                DatePicker(
                    "",
                    selection: Binding(
                        get: {
                            selectedTimeType == .wakeUp ? (wakeUpTime ?? Date()) : (windDownTime ?? Date())
                        },
                        set: { newValue in
                            if selectedTimeType == .wakeUp {
                                wakeUpTime = newValue
                            } else {
                                windDownTime = newValue
                            }
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(WheelDatePickerStyle())
                .colorScheme(.dark) // 다크 모드 강제 적용
                .labelsHidden()
            }
            .presentationDetents([.fraction(0.3)]) // 시트 높이 설정
            .presentationBackground(Color.gray09)

            // Done 버튼
            Button(action: {
                isPickerPresented = false
            }) {
                Text("Done")
                    .foregroundColor(Color.white)
                    .applyFont(.body_b_14)
            }
            .padding(.top, 14)
            .padding(.trailing, 16)
        }
    }
}
