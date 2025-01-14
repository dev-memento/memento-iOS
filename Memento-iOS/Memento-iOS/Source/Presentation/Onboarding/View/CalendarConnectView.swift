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
                Task {
                    await viewModel.signInWithGoogle()
                }
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
                    await viewModel.signInWithApple()
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
            viewModel.navigateToNext(.calendarConnect)
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
    }
}

#Preview {
    CalendarConnectView().environmentObject(OnboardingViewModel())
}
