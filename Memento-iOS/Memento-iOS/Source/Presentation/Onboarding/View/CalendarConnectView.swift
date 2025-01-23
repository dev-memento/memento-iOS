//
//  CalendarConnectView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/11/25.
//

import SwiftUI
import MDSKit

struct CalendarConnectView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel 

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .center) {
                CustomNavigationBar(
                    showBackButton: true,
                    showSkipButton: false,
                    backButtonAction: {
                        viewModel.navigateBack()
                    }
                )
                .padding([.trailing, .top], 16)

                CalendarConnectHeaderView()
                    .padding(.horizontal)

                CalendarConnectButtons()
                    .padding(.top, 133)

                Spacer()

                AppStartButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Header and Title View

private struct CalendarConnectHeaderView: View {
    var body: some View {
        ZStack {
            Image(.img_calendar)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 80)
                .foregroundColor(Color.gray09)
                .opacity(0.5)
                .offset(x: 110, y: 35)

            VStack(alignment: .center) {
                Text(OnboardingCalendarConnectText.calendarConnectHeaderTitle)
                    .applyFont(.title_b_24)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

// MARK: - CalendarConnectButtons

private struct CalendarConnectButtons: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
               
            } label: {
                HStack(spacing: 8) {
                    Image(.img_google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(OnboardingCalendarConnectText.connectGoogleCalendar)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10)

            Button {
                Task {
                    do {
                     try await viewModel.submitEventsToAPI()
                    } catch {
                        print("Failed to fetch events: \(error.localizedDescription)")
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(OnboardingCalendarConnectText.connectAppleCalendar)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10)

        }
    }
}

// MARK: - AppStartButton

private struct AppStartButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        Button {
            // 1. 먼저 데이터 전송
            viewModel.submitOnboardingData()
            
            // 2. 약간의 딜레이 후 화면 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut) {
                    viewModel.mementoStart = true
                }
            }
        } label: {
            Text(OnboardingCalendarConnectText.startMementoButton)
                .applyFont(.body_b_16)
                .foregroundColor(Color.black)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(Color.mainGreen)
        .frame(height: 50)
        .cornerRadius(2)
        // 3. 중복 탭 방지
        .disabled(viewModel.mementoStart)
    }
}

#Preview {
    CalendarConnectView().environmentObject(OnboardingViewModel(authViewModel: AuthViewModel()))
}
