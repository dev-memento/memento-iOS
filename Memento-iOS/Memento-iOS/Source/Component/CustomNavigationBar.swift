//
//  CustomNavigationBar.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/14/25.
//

import SwiftUI
import MDSKit
struct CustomNavigationBar: View {
    
    // MARK: - Properties
    
    let title: String?
    let showBackButton: Bool
    let showSkipButton: Bool
    let backButtonAction: () -> Void
    let skipButtonAction: () -> Void
    
    // MARK: - Initialization
    
    init(
        title: String? = nil,
        showBackButton: Bool = true,
        showSkipButton: Bool = false,
        backButtonAction: @escaping () -> Void = {},
        skipButtonAction: @escaping () -> Void = {}
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.showSkipButton = showSkipButton
        self.backButtonAction = backButtonAction
        self.skipButtonAction = skipButtonAction
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // 왼쪽 버튼
            if showBackButton {
                Button(action: backButtonAction) {
                    Image(.btn_back)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray06)
                }
            } else {
                Spacer().frame(width: 48)
            }

            // 중앙 타이틀 (없을 경우에도 공간 유지)
            if let title = title {
                Text(title)
                    .applyFont(.body_b_16)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                Spacer().frame(maxWidth: .infinity) // 🔥 중앙 정렬용 빈 공간 확보
            }

            // 오른쪽 버튼
            if showSkipButton {
                Button(action: skipButtonAction) {
                    Text("Skip")
                        .applyFont(.body_b_14)
                        .foregroundColor(.gray06)
                }
                .frame(width: 48)
            } else {
                Spacer().frame(width: 48)
            }
        }
        .frame(height: 48)
    }
}
