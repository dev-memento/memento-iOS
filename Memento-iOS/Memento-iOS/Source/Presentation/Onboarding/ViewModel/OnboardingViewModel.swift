//
//  OnboardingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/12/25.
//

import Foundation
import Combine

// MARK: - OnBoardingNavigationDestination

enum OnBoardingNavigationDestination: String, Hashable {
    case sleepCycleSetting = "SleepCycleSettingView"
    case workSelection = "WorkSelectionView"
    case workPreference = "WorkPreferenceView"
    case calendarConnectView = "CalendarConnectView"
}

// MARK: - Data Transfer Object

struct OnboardingData {
    let sleepCycle: OnboardingViewModel.SleepCycleData
    let workSelection: OnboardingViewModel.WorkSelectionData
    let workPreference: OnboardingViewModel.WorkPreferenceData
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    
    // MARK: - Navigation
    
    @Published var navigationPath: [OnBoardingNavigationDestination] = []
    
    // MARK: - User Input Data
    
    @Published var sleepCycleData: SleepCycleData = SleepCycleData()
    @Published var workSelectionData: WorkSelectionData = WorkSelectionData()
    @Published var workPreferenceData: WorkPreferenceData = WorkPreferenceData()
    
    // MARK: - States
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    //    private let authService: AuthServiceProtocol
    //    private var cancellables = Set<AnyCancellable>()
    //
    //    init(authService: AuthServiceProtocol) {
    //        self.authService = authService
    //    }
    
    // MARK: - Navigation Methods
    
    func navigateToNext(_ destination: OnBoardingNavigationDestination) {
        navigationPath.append(destination)
    }
    
    func navigateBack() {
        navigationPath.removeLast()
    }
    
    // MARK: - Business logic : Auth Methods
    
    func signInWithGoogle() async {
        isLoading = true
        do {
            // Google 로그인 로직 구현
            navigateToNext(.sleepCycleSetting)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signInWithApple() async {
        isLoading = true
        do {
            // Apple 로그인 로직 구현
            navigateToNext(.sleepCycleSetting)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // MARK: - Onboarding Data Models
    
    struct SleepCycleData {
        var wakeUpTime: Date? = nil
        var sleepTime: Date? = nil
    }
    
    struct WorkSelectionData {
        var selectedCategory: String? = nil
        var customCategory: String = ""
        var selectedWorks: Set<String> = [] 
    }
    
    // MARK: - Onboarding Data Models
    
    struct WorkPreferenceData {
        var selectedAnswers: [UUID: Bool?] = [:] // 각 질문에 대한 선택 상태 저장
    }

    // MARK: - Business logic : 최종 데이터 제출
    
    func submitOnboardingData() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // 모든 온보딩 데이터를 서버에 제출하는 로직
        let onboardingData = OnboardingData(
            sleepCycle: sleepCycleData,
            workSelection: workSelectionData,
            workPreference: workPreferenceData
        )
        
        // API 호출 로직 구현
        try await submitToServer(onboardingData)
    }
    
    private func submitToServer(_ data: OnboardingData) async throws {
        // API 호출 구현
    }
}
