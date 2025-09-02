//
//  StartMementoView.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 9/2/25.
//

import SwiftUI
import MDSKit

struct StartMementoView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center) {
            CustomNavigationBar(
                showBackButton: true,
                showSkipButton: false,
                backButtonAction: {
                    viewModel.navigateBack()
                }
            )
            .padding([.trailing, .top], 16)
            
            Text(OnboardingStartMementoViewText.startMementoTitle)
                .applyFont(.title_b_24)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 98)

            Spacer()

            AppStartButton()
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
        }
        .background {
            Image(.img_bg_start)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}
private struct AppStartButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var authSession: AuthSession

    var body: some View {
        VStack(spacing: 0) {
            Image(.ic_start_character)
                .resizable()
                .scaledToFit()
                .frame(width: 58.46, height: 56.62)
            Button {
                // 1. 데이터 전송
                viewModel.submitOnboardingData()
                
                // 2. 전송 성공 시 → 세션 갱신
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut) {
                        authSession.shouldStartOnboarding = false
                        authSession.isLoggedIn = true
                    }
                }
            } label: {
                Text(OnboardingStartMementoViewText.startMementoButton)
                    .applyFont(.body_b_16)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                    .frame(maxWidth: .infinity)
            }
            .background(Color.black)
            .frame(height: 50)
            .cornerRadius(2)
            .disabled(!authSession.shouldStartOnboarding)
        }
    }
}

#Preview {
    StartMementoView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(AuthSession.shared)
}
