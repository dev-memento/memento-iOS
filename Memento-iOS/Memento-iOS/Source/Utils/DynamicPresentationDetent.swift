//
//  DynamicPresentationDetent.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

/// 화면 크기에 따라 동적으로 시트 높이를 조정하는 유틸리티
struct DynamicPresentationDetent {

    /// 기기 화면 크기에 따라 동적으로 Detent 값을 반환
    static func dynamicDetent(
        for type: PickerButtonType
    ) -> Set<PresentationDetent> {
        let screenHeight = UIScreen.main.bounds.height
        let detentHeight: CGFloat

        switch type {
        case .date:
            switch screenHeight {
            case 0..<668:          // 작은 기기
                detentHeight = 0.6
            case 668..<875:        // 중간 기기
                detentHeight = 0.53
            case 875..<957:        // 대형 기기
                detentHeight = 0.5
            default:
                detentHeight = 0.6
            }

        case .time, .repeat, .endRepeat, .tag:
            switch screenHeight {
            case 0..<668:
                detentHeight = 0.43
            case 668..<875:
                detentHeight = 0.36
            case 875..<957:
                detentHeight = 0.33
            default:
                detentHeight = 0.43
            }
        }

        return [.fraction(detentHeight)]
    }
}
