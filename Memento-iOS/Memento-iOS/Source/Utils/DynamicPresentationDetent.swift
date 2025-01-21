//
//  DynamicPresentationDetent.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

/// 화면 크기에 따라 동적으로 시트 높이를 조정하는 유틸리티
struct DynamicPresentationDetent {

    let smallDeviceRange = CGFloat(0)..<CGFloat(668)    // 작은 기기
    let mediumDeviceRange = CGFloat(668)..<CGFloat(875) // 중간 기기
    let largeDeviceRange = CGFloat(875)..<CGFloat(957)  // 대형 기기

    /// 기기 화면 크기에 따라 동적으로 Detent 값을 반환
    static func dynamicDetent(
        for type: PickerButtonType
    ) -> Set<PresentationDetent> {
        let screenHeight = UIScreen.main.bounds.height
        let detentHeight: CGFloat
        let ranges = DynamicPresentationDetent()

        switch type {
        case .date:
            switch screenHeight {
            case ranges.smallDeviceRange: detentHeight = 0.6
            case ranges.mediumDeviceRange: detentHeight = 0.53
            case ranges.largeDeviceRange: detentHeight = 0.5
            default: detentHeight = 0.6
            }

        case .time, .repeat, .endRepeat, .tag:
            switch screenHeight {
            case ranges.smallDeviceRange: detentHeight = 0.43
            case ranges.mediumDeviceRange: detentHeight = 0.36
            case ranges.largeDeviceRange: detentHeight = 0.33
            default: detentHeight = 0.43
            }
        }

        return [.fraction(detentHeight)]
    }
}
