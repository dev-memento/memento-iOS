//
//  SettingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import Foundation
import UserNotifications
import UIKit

// MARK: - Setting Destinations

enum SettingNavigationDestination: Hashable {
    case Tag
    case TagDetail(TagItem?, Bool)
    case Time
    case Feedback
    case Terms
}

@MainActor
final class SettingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 네비게이션 스택을 관리
    @Published var navigationPath: [SettingNavigationDestination] = []
    @Published var isNotificationEnabled: Bool = false
    @Published var wakeUpTime: Date? = nil
    @Published var sleepTime: Date? = nil
    
    private let userUptimeService = UserUptimeAPIService()
    
    init() {
        refreshNotificationStatus()
    }
    
    /// 현재 알림 권한 상태 확인
    func refreshNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isNotificationEnabled = (settings.authorizationStatus == .authorized)
            }
        }
    }
    
    /// 앱 설정 화면으로 이동 (알림 설정 사용자가 직접 제어)
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Uptime 관련 API 통신 로직

extension SettingViewModel {
    
    // MARK: - 서버에서 Uptime 조회
    @MainActor
    func getUserUptime() {
        userUptimeService.getUserUptime { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(response) = result,
               let data = response?.data {
                self.wakeUpTime = Date.dateFromString(data.wakeUpTime, format: "HH:mm")
            }
        }
    }
    
    // MARK: - 서버에 Uptime 업데이트
    @MainActor
    func updateUserUptime() {
        guard let wake = wakeUpTime else { return }
        
        let request = UserUptimeRequest(wakeUpTime: wake.stringFromDate(with: "HH:mm"))
        
        userUptimeService.updateUserUptime(body: request) { _ in
            NotificationCenter.default.post(
                name: Notification.Name("updateUptime"),
                object: nil
            )
        }
    }
}

// MARK: - Setting Navigation Logic

extension SettingViewModel {
    /// 특정 화면으로 이동
    /// - Parameter destination: 이동할 화면의 목적지
    func navigateToNext(_ destination: SettingNavigationDestination) {
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
