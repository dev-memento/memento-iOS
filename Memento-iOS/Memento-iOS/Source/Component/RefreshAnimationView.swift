//
//  RefreshAnimationView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/24/25.
//

import SwiftUI

struct RefreshAnimationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
          
            Circle()
                .stroke(Color.green.opacity(0.4), lineWidth: 2)
                .scaleEffect(isAnimating ? 1.5 : 0.5)
                .opacity(isAnimating ? 0 : 1)
                .animation(
                    Animation.easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Circle()
                .stroke(Color.green.opacity(0.2), lineWidth: 2)
                .scaleEffect(isAnimating ? 2 : 0.8)
                .opacity(isAnimating ? 0 : 1)
                .animation(
                    Animation.easeOut(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.green)
                .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                .animation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .frame(width: 100, height: 100)
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}
