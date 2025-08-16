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

    /// 사용 예시:
    /// ```
    /// ExampleView()
    ///     .applyDynamicSheetForTagCount()
    /// ```
    ///
    /// - Returns: 동적으로 동작하는 시트 반환
    @ViewBuilder
    func applyDynamicSheetForTagCount() -> some View {
        if Tag.mockData.count > 3 {
            self.presentationContentInteraction(.scrolls)
                .scrollIndicators(.hidden)
                .presentationDetents([.fraction(0.33), .fraction(0.99)])
        } else {
            self.presentationDetents([.fraction(0.33)])
        }
    }
}
