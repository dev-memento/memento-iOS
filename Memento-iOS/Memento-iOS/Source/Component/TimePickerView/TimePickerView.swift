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

// UIDatePicker를 SwiftUI에서 사용하기 위한 wrapper
struct UIKitDatePicker: UIViewRepresentable {
    @Binding var selection: Date
    let displayedComponents: DatePickerComponents
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 30  // 30분 간격으로 설정
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selection
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        let parent: UIKitDatePicker
        
        init(_ parent: UIKitDatePicker) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selection = sender.date
        }
    }
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
                
                UIKitDatePicker(
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
                .colorScheme(.dark)
            }
            .presentationDetents([.fraction(0.3)])
            .presentationBackground(Color.gray09)
            
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
