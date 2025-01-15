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
        HStack(alignment: .center) {
            // Back Button
            if showBackButton {
                Button(action: backButtonAction) {
                    Image(.btn_back)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray06)
                }
            }
            
            // Title
            if let title = title {
                Text(title)
                    .applyFont(.body_b_16)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Skip Button
            if showSkipButton {
                Button(action: skipButtonAction) {
                    Text("Skip")
                        .applyFont(.body_b_14)
                        .foregroundColor(.gray06)
                }
            }
        }
        .frame(height: 48)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        CustomNavigationBar(
            showBackButton: true,
            showSkipButton: true,
            backButtonAction: {},
            skipButtonAction: {}
        )
        .padding()
        .background(Color.black)
        
        CustomNavigationBar(
            title: "Title",
            showBackButton: true,
            showSkipButton: false,
            backButtonAction: {}
        )
        .padding()
        .background(Color.black)
    }
}
