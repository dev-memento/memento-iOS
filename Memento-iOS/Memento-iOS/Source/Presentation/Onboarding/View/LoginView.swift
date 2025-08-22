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
    @EnvironmentObject var authSession: AuthSession
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                BackgroundView()
                
                VStack(alignment: .center) {
                    LoginHeaderView()
                        .padding(.top, 115)
                    
                    LoginButtons()
                        .padding(.top, 103.2)
                        .environmentObject(authSession)
                    
                    TermsOfUseView()
                        .padding(.top, 18)
                    
                    Spacer()
                }
            }
            .onChange(of: authSession.shouldStartOnboarding) { oldValue, newValue in
                if newValue {
                    viewModel.navigationPath = [.sleepCycleSetting]
                }
            }
            .navigationDestination(for: OnboardingNavigationDestination.self) { destination in
                switch destination {
                case .sleepCycleSetting:
                    SleepCycleSettingView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(viewModel)
                case .workSelection:
                    WorkSelectionView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(viewModel)
                case .workPreference:
                    WorkPreferenceView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(viewModel)
                case .calendarConnect:
                    CalendarConnectView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(viewModel)
                        .environmentObject(authSession)
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
            
            Image(.img_logo_memento_white)
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
    @EnvironmentObject var authSession: AuthSession
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            // Google 로그인 버튼
            Button {
                authSession.signInWithGoogle()
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
            .disabled(authSession.isLoading)
            .opacity(authSession.isLoading ? 0.6 : 1)
            
            // Apple 로그인 버튼
            SignInWithAppleButton(
                onRequest: { request in
                    guard !authSession.isLoading else { return }
                    authSession.prepareAppleSignIn(request)
                },
                onCompletion: { result in
                    guard !authSession.isLoading else { return }
                    authSession.handleAppleSignInCompletion(result)
                }
            )
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 46)
            .background(Color.clear)
            .disabled(authSession.isLoading)
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
                    .allowsHitTesting(false)
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
            
            Link(OnboardingLoginText.termsOfUse, destination: URL(string: "https://memento.today/terms")!)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray04)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(OnboardingViewModel())
}
