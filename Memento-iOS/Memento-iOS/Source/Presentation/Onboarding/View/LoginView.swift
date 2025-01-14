//
//  LoginView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct LoginView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                BackgroundView()
                
                VStack(alignment: .center) {
                    LoginHeaderView()
                        .padding(.top, 115)
                    
                    LoginButtons()
                        .padding(.top, 103.2)
                    
                    TermsOfUseView()
                        .padding(.top, 18)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: OnBoardingNavigationDestination.self) { destination in
                switch destination {
                case .sleepCycleSetting:
                    SleepCycleSettingView()
                        .navigationBarBackButtonHidden()
                case .workSelection:
                    WorkSelectionView()
                        .navigationBarBackButtonHidden()
                case .workPreference:
                    WorkPreferenceView()
                        .navigationBarBackButtonHidden()
                case .calendarConnectView:
                    CalendarConnectView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

// MARK: - Header View

private struct LoginHeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text(StringLiteral.Onboarding.loginHeaderTitle)
                .applyFont(.title_b_24)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
                .frame(width: 49.38, height: 43.16)
                .padding(.top, 98.64)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Login Buttons

private struct LoginButtons: View {
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
                    
                    Text(StringLiteral.Onboarding.googleButton)
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
                    
                    Text(StringLiteral.Onboarding.appleButton)
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

// MARK: - Terms Of Use View

private struct TermsOfUseView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text(StringLiteral.Onboarding.agreeToMemento)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray07)
            
            Link(StringLiteral.Onboarding.termsOfUse, destination: URL(string: "https://www.naver.com")!)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray04)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(OnboardingViewModel())
}
