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
}
