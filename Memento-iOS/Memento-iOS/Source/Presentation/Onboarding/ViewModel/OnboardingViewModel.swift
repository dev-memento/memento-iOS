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
    
    let authViewModel: AuthViewModel
    let userInfoAPIService = UserInfoAPIService()
    let userUptimeAPIService = UserUptimeAPIService()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
        setupAuthStateSubscription()
        checkAuthenticationStatus()
    }
    
    // 토큰 체크 메서드 추가
    func checkAuthenticationStatus() {
        if TokenKeychainManager.shared.hasValidToken() {
            mementoStart = true
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
    
    func handleGoogleLogin() {
        authViewModel.signInWithGoogle()
    }
    
    func handleAppleLogin(request: ASAuthorizationAppleIDRequest) {
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
        
        submitToServer(onboardingData)
    }
    
    /// 서버로 데이터 전송 로직
    func submitToServer(_ data: OnboardingData) {
        // OnboardingData를 UserInfoRequest로 변환
        let userInfoRequest = UserInfoRequest(onboardingData: data)
        
        userInfoAPIService.updateUserInfo(request: userInfoRequest) { result in
            switch result {
            case .success(let response):
                print("온보딩 데이터 전송 성공: \(response?.message)")
            default:
                print("회원 개인 정보 업데이트 실패")
            }
        }
    }
}

//MARK: - APPLE 캘린더 연동

extension OnboardingViewModel {

    func submitEventsToAPI() async {
        do {
            // 캘린더 이벤트 가져오기
            let events = try await fetchEventsForTwoYears()
            print("[DEBUG] 이벤트 가져오기 성공: \(events.count)개")
            
            // 이벤트를 AppleSchedule 형식으로 변환
            let appleSchedules = events.map { event -> AppleSchedule in
                let dateFormatter = ISO8601DateFormatter()
                return AppleSchedule(
                    description: event.title ?? "제목 없음",
                    startDate: dateFormatter.string(from: event.startDate),
                    endDate: dateFormatter.string(from: event.endDate),
                    isAllDay: event.isAllDay
                )
            }
            
            // API 요청 생성
            let request = AppleScheduleListRequest(events: appleSchedules)
            
            // API 호출
            let apiService = AppleSchedulesAPIService()
            apiService.submitSchedules(request: request) { result in
                switch result {
                case .success(let response):
                    print("[INFO] 스케줄 전송 성공")
                default:
                    print("[INFO] 스케줄 전송 실패")
                }
            }
        } catch {
            print("[ERROR] 이벤트 가져오기 실패: \(error.localizedDescription)")
        }
    }
    
    func fetchEventsForTwoYears() async throws -> [EKEvent] {
        let store = EKEventStore()
        
        // 권한 요청
        guard try await store.requestFullAccessToEvents() else {
            throw NSError(domain: "CalendarAccessError", code: 1, userInfo: [NSLocalizedDescriptionKey: "캘린더 접근 권한이 없습니다."])
        }
        
        // 현재 날짜 계산
        let currentDate = Date()
        
        // -1년 및 +1년 날짜 계산
        guard let startDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate),
              let endDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) else {
            throw NSError(domain: "DateCalculationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "날짜 계산에 실패했습니다."])
        }
        
        // 이벤트 조건 생성
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        // 이벤트 가져오기
        let events = store.events(matching: predicate)
        return events.sorted { $0.startDate < $1.startDate }
    }
    
    func printEvents(_ events: [EKEvent]) {
        guard !events.isEmpty else {
            print("이번 달에 등록된 일정이 없습니다.")
            return
        }
        
        for event in events {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let startDate = formatter.string(from: event.startDate)
            let endDate = formatter.string(from: event.endDate)
            
            print("""
            제목: \(event.title ?? "제목 없음") (타입: \(type(of: event.title)))
            시작: \(startDate) (타입: \(type(of: startDate)))
            종료: \(endDate) (타입: \(type(of: endDate)))
            위치: \(event.location ?? "위치 정보 없음") (타입: \(type(of: event.location)))
            참석자: \(event.attendees?.map { $0.name ?? "참석자 이름 없음" }.joined(separator: ", ") ?? "참석자 없음") (타입: \(type(of: event.attendees)))
            알림: \(event.alarms?.map { $0.relativeOffset.description }.joined(separator: ", ") ?? "알림 없음") (타입: \(type(of: event.alarms)))
            반복 여부: \(event.recurrenceRules != nil ? "반복 이벤트" : "단일 이벤트") (타입: \(type(of: event.recurrenceRules)))
            올데이 여부: \(event.isAllDay ? "올데이 일정" : "시간 지정 일정") (타입: \(type(of: event.isAllDay)))
            노트: \(event.notes ?? "노트 없음") (타입: \(type(of: event.notes)))
            URL: \(event.url?.absoluteString ?? "URL 없음") (타입: \(type(of: event.url)))
            --------------
            """)
        }
    }
}
