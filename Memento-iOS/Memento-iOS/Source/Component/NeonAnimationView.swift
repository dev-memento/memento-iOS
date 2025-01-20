//
//  NeonAnimationView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/17/25.
//

import SwiftUI

struct NeonAnimationView: View {
    
    @State private var gradientColors: [Color] = [Color.purple, Color.blue, Color.green]
    @State private var lightBrightness: Double = 0.5
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .strokeBorder(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 8
            )
            .frame(width: width, height: height)
            .shadow(color: gradientColors.first?.opacity(lightBrightness) ?? Color.white.opacity(lightBrightness), radius: 20)
            .shadow(color: gradientColors.last?.opacity(lightBrightness) ?? Color.white.opacity(lightBrightness), radius: 30)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    lightBrightness = 1.0
                }
                startColorAnimation()
            }
            .blur(radius: 1.5)
        
    }
    
    private func startColorAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                let shuffledColors = gradientColors.shuffled()
                gradientColors = shuffledColors
            }
        }
    }
}

#Preview {
    NeonAnimationView(
        width: UIScreen.main.bounds.width * 0.95,
        height: UIScreen.main.bounds.height * 0.90
    )
}

#Preview {
    NeonAnimationView(
        width: 343,
        height: 172
    )
}
