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
                CustomNavigationBar()
                    .padding(.trailing, 16)
                    .padding(.top, 16)

                HeaderTitleView()
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

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        HStack(alignment: .top) {
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
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
    var body: some View {
        ZStack {
            Image(.img_calendar)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 80)
                .foregroundColor(Color.gray09)
                .opacity(0.5)
                .offset(x: 110, y: 35)

            VStack(alignment: .center, spacing: 10) {
                Text("Connect your calendar")
                    .applyFont(.title_b_24)
                    .foregroundColor(.white)

                Text("for seamless scheduling.")
                    .applyFont(.title_b_24)
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

                    Text("Connect Google Calendar")
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

                    Text("Connect Apple Calendar")
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
            viewModel.navigateToNext(.calendarConnectView) // Adjust if needed
        } label: {
            Text("Start MEMENTO")
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
