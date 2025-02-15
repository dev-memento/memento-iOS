//
//  DynamicPresentationDetent.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

/// 기기 크기 카테고리
private enum DeviceSizeCategory {
    case small, medium, large
}

/// 화면 크기에 따라 동적으로 시트 높이를 조정하는 유틸리티
struct DynamicPresentationDetent {

    static let smallDeviceRange = CGFloat(0)..<CGFloat(668)    // 작은 기기
    static let mediumDeviceRange = CGFloat(668)..<CGFloat(875) // 중간 기기
    static let largeDeviceRange = CGFloat(875)..<CGFloat(957)  // 대형 기기

    /// 기기 화면 크기에 따라 Detent 높이를 계산
    static func dynamicDetent(for type: PickerButtonType) -> Set<PresentationDetent> {
        let screenHeight = UIScreen.main.bounds.height
        let detentHeight = detentHeight(for: type, deviceSize: screenHeight)
        return [.fraction(detentHeight)]
    }

    /// Detent 높이를 결정하는 함수
    private static func detentHeight(for type: PickerButtonType, deviceSize: CGFloat) -> CGFloat {
        let heightCategory = categorizeDeviceSize(deviceSize)

        switch type {
        case .addTodo(let todoType):
            return heightFor(todoType, in: heightCategory)
        case .addSchedule(let scheduleType):
            return heightFor(scheduleType, in: heightCategory)
        }
    }

    /// 기기의 화면 크기에 따라 카테고리 결정
    private static func categorizeDeviceSize(_ size: CGFloat) -> DeviceSizeCategory {
        switch size {
        case smallDeviceRange: return .small
        case mediumDeviceRange: return .medium
        case largeDeviceRange: return .large
        default: return .large
        }
    }

    /// 화면 크기별 Detent 높이 설정
    private static func heightFor(
        _ type: AddTodoPickerButtonType,
        in category: DeviceSizeCategory
    ) -> CGFloat {
        switch (type, category) {
        case (.date, .small): return 0.65
        case (.date, .medium): return 0.58
        case (.date, .large): return 0.55
        case (.tag, _): return 0
        case (.priority, .small): return 0.8
        case (.priority, .medium): return 0.73
        case (.priority, .large): return 0.7
        }
    }

    private static func heightFor(
        _ type: AddSchedulePickerButtonType,
        in category: DeviceSizeCategory
    ) -> CGFloat {
        switch (type, category) {
        case (.date, .small): return 0.6
        case (.date, .medium): return 0.53
        case (.date, .large): return 0.5
        case (.time, .small), (.tag, .small): return 0.43
        case (.time, .medium), (.tag, .medium): return 0.36
        case (.time, .large), (.tag, .large): return 0.33
        }
    }
}
