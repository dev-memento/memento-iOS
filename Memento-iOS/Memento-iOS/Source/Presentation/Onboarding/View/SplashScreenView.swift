//
//  SplashScreenView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/24/25.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var showLottieAnimation: Bool
    
    var body: some View {
        LottieView(animationName: "memento_logo_animation", loopMode: .playOnce) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showLottieAnimation = false
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.grayBlack)
    }
}
