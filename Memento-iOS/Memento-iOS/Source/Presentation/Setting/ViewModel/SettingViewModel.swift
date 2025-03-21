//
//  SettingViewModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import Foundation

// MARK: - Setting Destinations

/// 온보딩 화면의 네비게이션 목적지를 정의
enum SettingNavigationDestination: String, Hashable {
    case Tag = "Tag"
    case Time = "Time"
    case Integrations = "Integrations"
    case Feedback = "Feedback"
    case Terms = "Terms"
}

@MainActor
final class SettingViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 네비게이션 스택을 관리
    @Published var navigationPath: [SettingNavigationDestination] = []
    
    var wakeUpTime: Date? = nil
    var sleepTime: Date? = nil
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
