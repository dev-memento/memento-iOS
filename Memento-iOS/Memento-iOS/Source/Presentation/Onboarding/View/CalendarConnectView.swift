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
    @State private var isAppleCalendarButtonDisabled = false // 버튼 비활성화 상태
    @State private var showSuccessMessage = false // 성공 메시지 표시 상태
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
                // 구글 캘린더 연동 버튼 동작
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
                // 버튼 비활성화
                isAppleCalendarButtonDisabled = true
                
                // 캘린더 연동 API 호출
                Task {
                    do {
                        try await viewModel.submitEventsToAPI()
                        
                        // 성공 표시
                        withAnimation(.easeInOut) {
                            showSuccessMessage = true
                        }
                        
                        // 10초 후 성공 메시지 숨기기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSuccessMessage = false
                        }
                        
                    } catch {
                        print("Failed to fetch events: \(error.localizedDescription)")
                        isAppleCalendarButtonDisabled = false // 실패 시 다시 활성화
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
            .background(isAppleCalendarButtonDisabled ? Color.gray : Color.gray10)
            .disabled(isAppleCalendarButtonDisabled) // 버튼 비활성화
            
        }
        .overlay {
            if showSuccessMessage {
                VStack {
                    ZStack {
                        VStack(spacing: 16) {
                            // 아이콘
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.mainGreen)
                            
                            // 메시지
                            Text("연동 성공!")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.gray02)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray09)
                                .shadow(radius: 10)
                        )
                    }
                }
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showSuccessMessage = false
                        }
                    }
                }
            }
        }
    }
}
private struct AppStartButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @EnvironmentObject var authSession: AuthSession

    var body: some View {
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
            Text(OnboardingCalendarConnectText.startMementoButton)
                .applyFont(.body_b_16)
                .foregroundColor(Color.black)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(Color.mainGreen)
        .frame(height: 50)
        .cornerRadius(2)
        .disabled(!authSession.shouldStartOnboarding)
    }
}

#Preview {
    CalendarConnectView().environmentObject(OnboardingViewModel())
}
