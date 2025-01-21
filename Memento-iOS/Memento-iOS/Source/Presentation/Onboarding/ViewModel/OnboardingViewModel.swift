//
//  OnboardingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/12/25.
//

import Foundation
import Combine
import AuthenticationServices

// MARK: - Navigation Destinations

/// 온보딩 화면의 네비게이션 목적지를 정의
enum OnboardingNavigationDestination: String, Hashable {
    case sleepCycleSetting = "SleepCycleSettingView"
    case workSelection = "WorkSelectionView"
    case workPreference = "WorkPreferenceView"
    case calendarConnect = "CalendarConnectView"
}

// MARK: - Data Models

/// 수면 주기 데이터 모델
struct SleepCycleData {
    var wakeUpTime: Date? = nil
    var sleepTime: Date? = nil
}

/// 작업 선택 데이터 모델
struct WorkSelectionData {
    var selectedCategory: String? = nil
    var customCategory: String = ""
    var selectedWorks: Set<String> = []
}

/// 작업 선호도 데이터 모델
struct WorkPreferenceData {
    var selectedAnswers: [UUID: Bool?] = [:]
}

// MARK: - Data Transfer Object

/// 서버에 전달할 온보딩 데이터를 구조화한 객체
struct OnboardingData {
    let sleepCycle: SleepCycleData
    let workSelection: WorkSelectionData
    let workPreference: WorkPreferenceData
}


// MARK: - OnboardingViewModel Core
@MainActor
final class OnboardingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 네비게이션 스택을 관리
    @Published var navigationPath: [OnboardingNavigationDestination] = []
    
    /// 사용자 입력 데이터
    @Published var sleepCycleData: SleepCycleData = SleepCycleData()
    @Published var workSelectionData: WorkSelectionData = WorkSelectionData()
    @Published var workPreferenceData: WorkPreferenceData = WorkPreferenceData()
    
    /// UI 상태 관리
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var authViewModel: AuthViewModel
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        setupAuthStateSubscription()
        
        
        // MARK: - Submit Onboarding Data
        
        /// 온보딩 데이터를 서버로 전송
        func submitOnboardingData() async throws {
            isLoading = true
            defer { isLoading = false }
            
            // 온보딩 데이터 생성
            let onboardingData = OnboardingData(
                sleepCycle: sleepCycleData,
                workSelection: workSelectionData,
                workPreference: workPreferenceData
            )
            
            // 서버로 데이터 전송
            try await submitToServer(onboardingData)
        }
        
        /// 서버로 데이터 전송 로직
        func submitToServer(_ data: OnboardingData) async throws {
            // 서버 API 호출 구현
        }
    }
}

// MARK: - Onboarding Navigation Logic
extension OnboardingViewModel {
    /// 특정 화면으로 이동
    /// - Parameter destination: 이동할 화면의 목적지
    func navigateToNext(_ destination: OnboardingNavigationDestination) {
        navigationPath.append(destination)
    }
    
    /// 현재 화면에서 뒤로 이동
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    /// 네비게이션 스택 리셋
    func resetNavigation() {
        navigationPath.removeAll()
    }
}

// MARK: - Authentication Handling
extension OnboardingViewModel {
    
    func handleGoogleLogin() async {
        isLoading = true
        
        // Google 로그인 요청
        await authViewModel.signInWithGoogle()
        
        // 로그인 결과 처리
        if authViewModel.isAuthenticated {
            // 로그인 성공 시 SleepCycleSetting 화면으로 전환
            navigateToNext(.sleepCycleSetting)
        } else if let error = authViewModel.errorMessage {
            // 로그인 실패 시 에러 메시지 표시
            errorMessage = error
        }
        
        isLoading = false
    }

    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) async {
        isLoading = true
        
        // Apple 로그인 요청 생성
        authViewModel.send(action: .appleLogin(request))
    }

    // AuthViewModel 상태 변화 감지를 위한 메서드
    private func setupAuthStateSubscription() {
        authViewModel.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                guard let self = self else { return }
                if isAuthenticated {
                    self.navigateToNext(.sleepCycleSetting)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helper Methods for OnboardingViewModel
extension OnboardingViewModel {
    
    /// SleepCycle 화면에서 Next 버튼 활성화 여부를 확인
    var isNextButtonEnabledForSleepCycle: Bool {
        sleepCycleData.wakeUpTime != nil && sleepCycleData.sleepTime != nil
    }
    
    /// WorkPreference 화면에서 Next 버튼 활성화 여부를 확인
    var isNextButtonEnabledForWorkPreference: Bool {
        SurveyQuestion.mockData.allSatisfy { workPreferenceData.selectedAnswers[$0.id] != nil }
    }
}
