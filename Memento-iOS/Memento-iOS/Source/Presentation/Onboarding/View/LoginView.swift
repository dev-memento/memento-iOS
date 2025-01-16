//
//  LoginView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI

import GoogleSignIn
import GoogleSignInSwift
import MDSKit
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                BackgroundView()
                
                VStack(alignment: .center) {
                    LoginHeaderView()
                        .padding(.top, 115)
                    
                    LoginButtons(authViewModel: authViewModel)
                        .padding(.top, 103.2)
                    
                    TermsOfUseView()
                        .padding(.top, 18)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: OnboardingNavigationDestination.self) { destination in
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
                case .calendarConnect:
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
            Text(OnboardingLoginText.loginHeaderTitle)
                .applyFont(.title_b_24)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Image(.img_main_logo)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 72)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Login Buttons

private struct LoginButtons: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
                authViewModel.send(action: .googleLogin)
            } label: {
                HStack(spacing: 8) {
                    Image(.img_google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(OnboardingLoginText.googleButton)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 46)
            .background(Color.gray10)
            
            SignInWithAppleButton(
                onRequest: { request in
                    authViewModel.send(action: .appleLogin(request))
                },
                onCompletion: { result in
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
            )
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 46)
            .background(Color.clear) // Apple 버튼 투명 처리
            .overlay(
                HStack(spacing: 8) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text(OnboardingLoginText.appleButton)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                    .frame(maxWidth: .infinity)
                    .frame(height: 46)
                    .background(Color.gray10)
                    .allowsHitTesting(false) // 오버레이는 터치 이벤트를 차단
            )
        }
    }
}

// MARK: - Terms Of Use View

private struct TermsOfUseView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text(OnboardingLoginText.agreeToMemento)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray07)
            
            Link(OnboardingLoginText.termsOfUse, destination: URL(string: "https://www.naver.com")!)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray04)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(OnboardingViewModel())
}
