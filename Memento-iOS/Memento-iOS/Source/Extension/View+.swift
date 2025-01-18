//
//  View+.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import SwiftUI

extension View {
    
    /// navigationBarTitleText의 색상을 변경해주는 메소드입니다.
    /// 사용법: .navigationBarTitleTextColor(.red)
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }

    /// 태그 개수에 따라 시트의 동작과 크기를 동적으로 조정하는 메서드
    ///
    /// - 태그 개수가 4개를 초과하면 시트는 스크롤이 가능하며 두 가지 높이(`0.33`, `0.99`)로 조정
    /// - 태그 개수가 4개 이하일 경우, 고정된 높이(`0.33`)로만 표시되며 스크롤 비활성화
    ///
    /// 사용 예시:
    /// ```
    /// ExampleView()
    ///     .applyDynamicSheetForTagCount()
    /// ```
    ///
    /// - Returns: 동적으로 동작하는 시트 반환
    @ViewBuilder
    func applyDynamicSheetForTagCount() -> some View {
        if Tag.mockData.count > 4 {
            self
                .presentationContentInteraction(.scrolls)
                .scrollIndicators(.hidden)
                .presentationDetents([.fraction(0.33), .fraction(0.99)])
        } else {
            self
                .presentationDetents([.fraction(0.33)])
        }
    }
}
