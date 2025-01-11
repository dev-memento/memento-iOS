//
//  SleepCycleSettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct SleepCycleSettingView: View {
    @State private var wakeUpTime: Date? = nil
    @State private var windDownTime: Date? = nil
    @State private var isPickerPresented: Bool = false
    @State private var selectedTimeType: TimeType = .wakeUp
    @Binding var path: [OnBoardingNavigationDestination]
    
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
                
                Spacer()
                
                NextButton(wakeUpTime: $wakeUpTime, windDownTime: $windDownTime, path: $path)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                
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
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7.5, height: 16.5)
                    .foregroundColor(.gray06)
            }
            
            Spacer()
            
            Button {
                path.append(.calendarConnectView) // 다음 화면으로 이동
            } label: {
                Text("Skip")
                    .applyFont(.body_b_14)
                    .foregroundColor(.gray06)
            }
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("1")
                .applyFont(.head_b_40)
                .foregroundColor(.gray07)
            
            
            Text("Set your")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
                .padding(.top, 18)
            
            Text("wake-up and")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
            
            Text("wind-down hours")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Time Selection View
private struct TimeSelectionView: View {
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: TimeType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            timeSelectionRow(
                icon: "mingcute_sun-line", // 디자인 시스템에 맞게 수정 필요
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
            //Image(icon)
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
                .foregroundColor(.white)
            
            Text(title)
                .applyFont(.title_b_22)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: action) {
                Text(time.map { $0.formattedDate(with: "hh:mm a") } ?? "00:00 AM")
                    .applyFont(.body_r_14)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .background(Color.gray09)
            }
            .frame(width: 94, height: 36)

        }
    }
}

// MARK: - Next Button
private struct NextButton: View {
    @Binding var wakeUpTime: Date?
    @Binding var windDownTime: Date?
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        Button {
            if wakeUpTime != nil && windDownTime != nil {
                path.append(.workSelection)
            }
        } label: {
            Text("Next")
                .applyFont(.body_b_16)
                .foregroundColor((wakeUpTime != nil && windDownTime != nil) ? .black : .gray08)
                .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                .frame(maxWidth: .infinity)
        }
        .cornerRadius(2)
        .frame(height: 50)
        .background((wakeUpTime != nil && windDownTime != nil) ? Color.green : Color.gray10)
    }
}

#Preview {
    SleepCycleSettingView(path: .constant([]))
}

