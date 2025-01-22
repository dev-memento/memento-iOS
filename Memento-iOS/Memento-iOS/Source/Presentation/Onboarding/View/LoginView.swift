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
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                BackgroundView()
                
                VStack(alignment: .center) {
                    LoginHeaderView()
                        .padding(.top, 115)
                    
                    LoginButtons(authViewModel: viewModel.authViewModel) // viewModel에서 authViewModel 사용
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
        .onAppear {
            if viewModel.authViewModel.isAuthenticated {
                viewModel.authViewModel.isAuthenticated = false
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
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            // Google 로그인 버튼
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
            .disabled(authViewModel.isLoading)  // 로딩 중일 때 버튼 비활성화
            .opacity(authViewModel.isLoading ? 0.6 : 1)  // 로딩 중일 때 버튼 반투명하게
            
            // Apple 로그인 버튼
            SignInWithAppleButton(
                onRequest: { request in
                    guard !authViewModel.isLoading else { return }  // 로딩 중이면 실행 방지
                    authViewModel.send(action: .appleLogin(request))
                },
                onCompletion: { result in
                    guard !authViewModel.isLoading else { return }  // 로딩 중이면 실행 방지
                    authViewModel.send(action: .appleLoginCompletion(result))
                }
            )
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 46)
            .background(Color.clear)
            .disabled(authViewModel.isLoading)  // 로딩 중일 때 버튼 비활성화
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
        .environmentObject(OnboardingViewModel(authViewModel: AuthViewModel()))
}
