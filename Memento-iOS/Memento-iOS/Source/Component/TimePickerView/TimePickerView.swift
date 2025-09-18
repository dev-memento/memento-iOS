//
//  TimePickerView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/11/25.
//

import SwiftUICore
import SwiftUI

/// 선택 가능한 시간 유형
enum TimeType {
    case wakeUp
    case windDown
}

// MARK: - Custom Picker (Hour + 00/30 Minute)

struct HalfHourPicker: UIViewRepresentable {
    @Binding var selection: Date
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.hour, .minute], from: selection)
        uiView.selectRow(comps.hour ?? 0, inComponent: 0, animated: true)
        uiView.selectRow((comps.minute ?? 0) / 30, inComponent: 1, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        let parent: HalfHourPicker
        let hours = Array(0..<24)
        let minutes = [0, 30]
        
        init(_ parent: HalfHourPicker) {
            self.parent = parent
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? hours.count : minutes.count
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            let totalWidth = pickerView.frame.width
            return component == 0 ? totalWidth * 0.3 : totalWidth * 0.3
        }
        
        func pickerView(_ pickerView: UIPickerView,
                         attributedTitleForRow row: Int,
                         forComponent component: Int) -> NSAttributedString? {
             let text = component == 0 ? "\(hours[row])" : String(format: "%02d", minutes[row])
             return NSAttributedString(string: text, attributes: [
                 .foregroundColor: UIColor.white,
                 .font: UIFont.systemFont(ofSize: 20, weight: .medium) 
             ])
         }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let hour = hours[pickerView.selectedRow(inComponent: 0)]
            let minute = minutes[pickerView.selectedRow(inComponent: 1)]
            var comps = Calendar.current.dateComponents([.year, .month, .day], from: parent.selection)
            comps.hour = hour
            comps.minute = minute
            if let newDate = Calendar.current.date(from: comps) {
                parent.selection = newDate
            }
        }
    }
}

// MARK: - TimePickerView

struct TimePickerView: View {
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: TimeType
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer()
                
                HalfHourPicker(
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
                    )
                )
                .frame(height: 200)
            }
            .presentationDetents([.fraction(0.3)])
            .presentationBackground(Color.gray09)
            
            Button(action: {
                isPickerPresented = false
            }) {
                Text("Done")
                    .foregroundColor(Color.white)
                    .applyFont(.body_b_14)
                    .frame(minWidth: 60, minHeight: 60)
            }
            .padding(.top, 14)
            .padding(.trailing, 16)
        }
    }
}
