//
//  OnboardingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/12/25.
//

import Foundation
import Combine

// MARK: - Navigation Destinations

/// 온보딩 화면의 네비게이션 목적지를 정의
enum OnboardingNavigationDestination: String, Hashable {
    case sleepCycleSetting = "SleepCycleSettingView"
    case workSelection = "WorkSelectionView"
    case workPreference = "WorkPreferenceView"
    case calendarConnect = "CalendarConnectView"
}

// MARK: - Data Transfer Object

/// 서버에 전달할 온보딩 데이터를 구조화한 객체
struct OnboardingData {
    let sleepCycle: OnboardingViewModel.SleepCycleData
    let workSelection: OnboardingViewModel.WorkSelectionData
    let workPreference: OnboardingViewModel.WorkPreferenceData
}

// MARK: - Onboarding ViewModel

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

    // MARK: - Navigation Methods

    /// 특정 화면으로 이동
    func navigateToNext(_ destination: OnboardingNavigationDestination) {
        navigationPath.append(destination)
    }

    /// 현재 화면에서 뒤로 이동
    func navigateBack() {
        navigationPath.removeLast()
    }

    // MARK: - SleepCycle Data Model and Logic

    struct SleepCycleData {
        var wakeUpTime: Date? = nil
        var sleepTime: Date? = nil
    }

    /// SleepCycle 화면에서 Next 버튼 활성화 여부를 확인
    var isNextButtonEnabledForSleepCycle: Bool {
        sleepCycleData.wakeUpTime != nil && sleepCycleData.sleepTime != nil
    }

    // MARK: - WorkSelection Data Model and Logic

    struct WorkSelectionData {
        var selectedCategory: String? = nil
        var customCategory: String = ""
        var selectedWorks: Set<String> = []
    }

    // MARK: - WorkPreference Data Model and Logic

    struct WorkPreferenceData {
        var selectedAnswers: [UUID: Bool?] = [:]
    }

    /// WorkPreference 화면에서 Next 버튼 활성화 여부를 확인
    var isNextButtonEnabledForWorkPreference: Bool {
        SurveyQuestion.mockData.allSatisfy { workPreferenceData.selectedAnswers[$0.id] != nil }
    }

    // MARK: - Authentication Methods

    /// Google 로그인 처리
    func signInWithGoogle() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Google 로그인 로직 구현
            navigateToNext(.sleepCycleSetting)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Apple 로그인 처리
    func signInWithApple() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Apple 로그인 로직 구현
            
            navigateToNext(.sleepCycleSetting)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

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
    private func submitToServer(_ data: OnboardingData) async throws {
        // 서버 API 호출 구현
    }
}
