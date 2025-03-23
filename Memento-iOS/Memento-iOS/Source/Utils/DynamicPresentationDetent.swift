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

    static var currentDeviceSize: DeviceSizeCategory {
        let height = UIScreen.main.bounds.height

        switch height {
        case ..<812   : return .small  // SE
        case 812..<875: return .medium // mini, pro
        default       : return .large  // plus, max
        }
    }
}

/// 화면 크기에 따라 동적으로 시트 높이를 조정하는 유틸리티
struct DynamicPresentationDetent {

    /// 기기 화면 크기에 따라 바텀 시트의 높이를 계산
    static func dynamicDetent(for type: PickerButtonType) -> Set<PresentationDetent> {
        let device = DeviceSizeCategory.currentDeviceSize
        return [.fraction(fraction(for: type, on: device))]
    }

    private static func fraction(
        for type: PickerButtonType,
        on device: DeviceSizeCategory
    ) -> CGFloat {
        switch type {
        case .addTodo(let subtype):
            return fractionForAddTodo(subtype: subtype, device: device)
        case .addSchedule(let subtype):
            return fractionForAddSchedule(subtype: subtype, device: device)
        }
    }

    private static func fractionForAddTodo(
        subtype: AddTodoPickerButtonType,
        device: DeviceSizeCategory
    ) -> CGFloat {
        switch subtype {
        case .date:
            switch device {
            case .small : return AddTodoDateFraction.small
            case .medium: return AddTodoDateFraction.medium
            case .large : return AddTodoDateFraction.large
            }
        case .priority:
            switch device {
            case .small : return AddTodoPriorityFraction.small
            case .medium: return AddTodoPriorityFraction.medium
            case .large : return AddTodoPriorityFraction.large
            }
        default: return 0
        }
    }

    private static func fractionForAddSchedule(
        subtype: AddSchedulePickerButtonType,
        device: DeviceSizeCategory
    ) -> CGFloat {
        switch subtype {
        case .date:
            switch device {
            case .small : return AddScheduleDateFraction.small
            case .medium: return AddScheduleDateFraction.medium
            case .large : return AddScheduleDateFraction.large
            }
        case .time:
            switch device {
            case .small : return AddScheduleTimeFraction.small
            case .medium: return AddScheduleTimeFraction.medium
            case .large : return AddScheduleTimeFraction.large
            }
        default: return 0
        }
    }
}
