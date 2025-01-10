//
//  SleepCycleSettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//
import SwiftUI

struct SleepCycleSettingView: View {
    @State private var wakeUpTime: Date? = nil
    @State private var windDownTime: Date? = nil
    @State private var isPickerPresented: Bool = false // DatePicker 표시 여부
    @State private var selectedTimeType: TimeType = .wakeUp
    @Binding var path: [String] // Navigation 경로를 관리하는 바인딩 변수

    enum TimeType {
        case wakeUp
        case windDown
    }

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                CustomNavigationBar(path: $path)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                StepProgressBar(currentStep: 1, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                
                HeaderTitleView()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                TimeSelectionView(
                    wakeUpTime: $wakeUpTime,
                    windDownTime: $windDownTime,
                    isPickerPresented: $isPickerPresented,
                    selectedTimeType: $selectedTimeType
                )
                .padding(.horizontal, 16)
                .padding(.top, 80)
                
                NextButton(wakeUpTime: $wakeUpTime, windDownTime: $windDownTime, path: $path)
                    .padding(.horizontal, 16)
                    .padding(.top, 289)
                
                Spacer()
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            TimePickerView(
                isPickerPresented: $isPickerPresented,
                selectedTimeType: $selectedTimeType,
                wakeUpTime: $wakeUpTime,
                windDownTime: $windDownTime
            )
        }
    }
}

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @Binding var path: [String]

    var body: some View {
        HStack(alignment: .top) {
            Button {
                path.removeLast() // 이전 화면으로 이동
            } label: {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7.5, height: 16.5)
                    .foregroundColor(Color("gray06"))
            }
            
            Spacer()
            
            Button {
                path.append("WorkSelectionView") // 다음 화면으로 이동
            } label: {
                Text("Skip")
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray06"))
            }
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("1")
                .font(.system(size: 40))
                .foregroundColor(Color("gray07"))
            
            
            Text("Set your")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
            
            Text("wake-up and")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
            
            Text("wind-down hours")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
        }
    }
}

// MARK: - Time Selection View
private struct TimeSelectionView: View {
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: SleepCycleSettingView.TimeType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            timeSelectionRow(
                icon: "mingcute_sun-line",
                title: "Wake-up",
                time: wakeUpTime,
                action: {
                    selectedTimeType = .wakeUp
                    isPickerPresented = true // TimePickerView 작동
                }
            )
            
            timeSelectionRow(
                icon: "mingcute_bed-line",
                title: "Wind-down",
                time: windDownTime,
                action: {
                    selectedTimeType = .windDown
                    isPickerPresented = true
                }
            )
        }
    }
    
    private func timeSelectionRow(icon: String, title: String, time: Date?, action: @escaping () -> Void) -> some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
            
            Text(title)
                .font(.system(size: 22))
                .foregroundColor(Color.white)
            
            Spacer()
            
            Button(action: action) {
                Text(time.map { timeFormatter.string(from: $0) } ?? "00:00 AM")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color("gray09"))
            }
        }
    }
}

// MARK: - Next Button
private struct NextButton: View {
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?
    @Binding var path: [String]

    var body: some View {
        Button {
            if wakeUpTime != nil && windDownTime != nil {
                path.append("WorkSelectionView")
            }
        } label: {
            Text("Next")
                .font(.system(size: 16))
                .foregroundColor((wakeUpTime != nil && windDownTime != nil) ? .black : Color("gray08"))
                .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                .frame(maxWidth: .infinity)
        }
        .cornerRadius(2)
        .background((wakeUpTime != nil && windDownTime != nil) ? Color.green : Color("gray10"))
        .padding(.bottom, 10) // 버튼 아래쪽 여백 추가
    }
}

// MARK: - Time Picker View
private struct TimePickerView: View {
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: SleepCycleSettingView.TimeType
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
                            selectedTimeType == .wakeUp ? (wakeUpTime = newValue) : (windDownTime = newValue)
                        }
                    ),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(WheelDatePickerStyle())
                .colorScheme(.dark) // 다크 모드 강제 적용
                .labelsHidden()
            }
            .presentationDetents([.fraction(0.3)]) // 시트 높이 설정
            .presentationBackground(Color("gray09"))
            
            // Done 버튼
            Button(action: {
                isPickerPresented = false // 시트 닫기
            }) {
                Text("Done")
                    .foregroundColor(Color.white)
                    .font(.system(size: 14))
            }
            .padding(.top, 14)
            .padding(.trailing, 16)
        }
    }
}

// MARK: - Time Formatter
private var timeFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a" // 00:00 PM 형식
    return formatter
}

#Preview {
    SleepCycleSettingView(path: .constant([])) // 프리뷰용 바인딩 전달
}

