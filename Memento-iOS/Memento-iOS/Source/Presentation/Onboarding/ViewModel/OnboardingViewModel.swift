//
//  OnboardingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/12/25.
//

import Foundation
import Combine
import AuthenticationServices
import EventKit

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
    
    @Published var errorMessage: String?
    @Published var mementoStart: Bool = false
    
    private let userInfoAPIService = UserInfoAPIService()
    private let userUptimeAPIService = UserUptimeAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeNavigationPath() 
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
    
    /// 로그인 이후 최초 진입 -> 다시 뒤로가기 -> 재 로그인시 온보딩 다시 보이게 상태 구독
    private func observeNavigationPath() {
        $navigationPath
            .map(\.isEmpty)
            .removeDuplicates()
            .filter { $0 }
            .sink { _ in
                DispatchQueue.main.async {
                    AuthSession.shared.shouldStartOnboarding = false
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
    
    /// 선택된 카테고리를 서버에서 요구하는 형식으로 변환하고,
    /// WorkSelectionData의 selectedCategory에 저장합니다.
    func updateCategory(categoryName: String) {
        let transformedCategory = CategoryType.from(name: categoryName)
        workSelectionData.selectedCategory = transformedCategory
    }
}

// MARK: - Onboarding Data Submission

extension OnboardingViewModel {
    
    /// 온보딩 데이터를 서버로 전송
    func submitOnboardingData() {
        // 온보딩 데이터 생성
        let onboardingData = OnboardingData(
            sleepCycle: sleepCycleData,
            workSelection: workSelectionData,
            workPreference: workPreferenceData
        )
        
        submitOnboardingDataAndFinish(onboardingData)
    }
    
    /// 서버로 데이터 전송 로직
    func submitOnboardingDataAndFinish(_ data: OnboardingData) {
        // OnboardingData를 UserInfoRequest로 변환
        let userInfoRequest = UserInfoRequest(onboardingData: data)
        
        // 2) API 호출
        userInfoAPIService.updateUserInfo(request: userInfoRequest) { [weak self] result in
            Task { @MainActor in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    print("온보딩 데이터 전송 성공: \(response?.message ?? "-")")
                    // 온보딩 종료 → 탭으로
                    AuthSession.shared.shouldStartOnboarding = false
                    AuthSession.shared.isLoggedIn = true
                    
                    // 온보딩 네비 스택 정리
                    self.resetNavigation()
                    
                default:
                    self.errorMessage = "회원 개인 정보 업데이트 실패"
                }
            }
        }
    }
}

//MARK: - APPLE 캘린더 연동

extension OnboardingViewModel {
    
    func submitEventsToAPI() async {
        do {
            let events = try await CalendarService.shared.fetchEventsForTwoYears()
            let appleSchedules = events.map(CalendarService.convertToAppleSchedule)
            let request = AppleScheduleListRequest(events: appleSchedules)
            let apiService = AppleSchedulesAPIService()
            
            apiService.submitSchedules(request: request) { result in
                switch result {
                case .success:
                    print("[INFO] 스케줄 전송 성공")
                default:
                    print("[INFO] 스케줄 전송 실패")
                }
            }
        } catch {
            print("[ERROR] 이벤트 가져오기 실패: \(error.localizedDescription)")
        }
    }
}
