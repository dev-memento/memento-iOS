//
//  SleepCycleSettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct SleepCycleSettingView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel // 뷰모델 주입
    @State private var isPickerPresented: Bool = false
    @State private var selectedTimeType: TimeType = .wakeUp

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .leading) {
                CustomNavigationBar()
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                StepProgressBar(currentStep: 1, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                SleepCycleSettingHeaderView()
                    .padding(.horizontal)
                    .padding(.top, 8)

                TimeSelectionView(
                    wakeUpTime: $viewModel.sleepCycleData.wakeUpTime,
                    windDownTime: $viewModel.sleepCycleData.sleepTime,
                    isPickerPresented: $isPickerPresented,
                    selectedTimeType: $selectedTimeType
                )
                .padding(.horizontal, 16)
                .padding(.top, 80)

                Spacer()

                NextButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            TimePickerView(
                isPickerPresented: $isPickerPresented,
                selectedTimeType: $selectedTimeType,
                wakeUpTime: $viewModel.sleepCycleData.wakeUpTime,
                windDownTime: $viewModel.sleepCycleData.sleepTime
            )
        }
    }
}

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        HStack {
            Button {
                viewModel.navigateBack()
            } label: {
                Image(.btn_back)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.gray06)
            }

            Spacer()

            Button {
                viewModel.navigateToNext(.calendarConnectView)
            } label: {
                Text("Skip")
                    .applyFont(.body_b_14)
                    .foregroundColor(.gray06)
            }
        }
    }
}

// MARK: - Header and Title View
private struct SleepCycleSettingHeaderView: View {
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
                icon: .ic_sun_line,
                title: "Wake-up",
                time: wakeUpTime,
                action: {
                    selectedTimeType = .wakeUp
                    isPickerPresented = true
                }
            )

            timeSelectionRow(
                icon: .ic_bad,
                title: "Wind-down",
                time: windDownTime,
                action: {
                    selectedTimeType = .windDown
                    isPickerPresented = true
                }
            )
        }
    }

    private func timeSelectionRow(icon: MDSImageName, title: String, time: Date?, action: @escaping () -> Void) -> some View {
        HStack {
            Image(icon)
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
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        Button {
            if viewModel.sleepCycleData.wakeUpTime != nil && viewModel.sleepCycleData.sleepTime != nil {
                viewModel.navigateToNext(.workSelection)
            }
        } label: {
            Text("Next")
                .applyFont(.body_b_16)
                .foregroundColor((viewModel.sleepCycleData.wakeUpTime != nil && viewModel.sleepCycleData.sleepTime != nil) ? .black : .gray08)
                .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                .frame(maxWidth: .infinity)
        }
        .cornerRadius(2)
        .frame(height: 50)
        .background((viewModel.sleepCycleData.wakeUpTime != nil && viewModel.sleepCycleData.sleepTime != nil) ? Color.green : Color.gray10)
    }
}

#Preview {
    SleepCycleSettingView().environmentObject(OnboardingViewModel())
}
