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
    
    /// 조건에 따라 시트를 동적으로 적용
    /// 사용법: ExampleView().applyDynamicSheetForTagCount(10)
    @ViewBuilder
    func applyDynamicSheetForTagCount(tagCount: Int) -> some View {
        if tagCount > 3 {
            self.presentationContentInteraction(.scrolls)
                .scrollIndicators(.hidden)
                .presentationDetents([.fraction(0.33), .fraction(0.99)])
        } else {
            self.presentationDetents([.fraction(0.33)])
        }
    }
}
