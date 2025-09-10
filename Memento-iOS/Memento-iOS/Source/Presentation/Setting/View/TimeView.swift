//
//  TimeView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import SwiftUI
import MDSKit

struct TimeView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    @State private var isPickerPresented: Bool = false
    @State private var selectedTimeType: TimeType = .wakeUp
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                title: SettingsTimeViewText.navigationTitle,
                showBackButton: true,
                showSkipButton: false,
                backButtonAction: {
                    viewModel.navigateBack()
                }
            )
            .padding(.top, 25)
            
            TimeSelectionView(
                wakeUpTime: $viewModel.wakeUpTime,
                isPickerPresented: $isPickerPresented,
                selectedTimeType: $selectedTimeType
            )
            .padding(.horizontal, 16)
            .padding(.top, 25)
            
            Spacer()
        }
        .sheet(isPresented: $isPickerPresented, onDismiss: {
            viewModel.updateUserUptime()
        }) {
            TimePickerView(
                isPickerPresented: $isPickerPresented,
                selectedTimeType: $selectedTimeType,
                wakeUpTime: $viewModel.wakeUpTime,
                windDownTime: $viewModel.sleepTime
            )
        }
        .onAppear {
            viewModel.fetchUserUptime()
        }
    }
}

private struct TimeSelectionView: View {
    @Binding var wakeUpTime: Date?
    @Binding var isPickerPresented: Bool
    @Binding var selectedTimeType: TimeType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 29) {
            timeSelectionRow(
                icon: .ic_wakeup,
                title: SettingsTimeViewText.wakeUpTitle,
                time: wakeUpTime ?? Date(),
                action: {
                    selectedTimeType = .wakeUp
                    isPickerPresented = true
                }
            )
        }
    }
    
    private func timeSelectionRow(icon: MDSImageName, title: String, time: Date, action: @escaping () -> Void) -> some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 33, height: 33)
                .foregroundColor(.white)
            
            Text(title)
                .applyFont(.body_r_14)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: action) {
                Text(time.stringFromDate(with: "HH:mm"))
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

#Preview {
    TimeView()
}
