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

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            // 네온 효과 사각형
            // repeatForever(autoreverses: true)로 애니메이션이 끝나면 반대로 진행
            Rectangle()
                .strokeBorder(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 8
                )
                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.90)
                .shadow(color: Color.purple.opacity(lightBrightness), radius: 20)
                .shadow(color: Color.blue.opacity(lightBrightness), radius: 30)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        lightBrightness = 1.0
                    }
                }
                .blur(radius: 1.5)

                .onAppear {
                    startColorAnimation()
                }

            VStack {
                Text("Content View")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }

    private func startColorAnimation() {
        // 타이머로 색상을 일정 시간마다 변경
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                gradientColors = gradientColors.shuffled()
            }
        }
    }
}

struct NeonRectangleView_Previews: PreviewProvider {
    static var previews: some View {
        NeonAnimationView()
    }
}
