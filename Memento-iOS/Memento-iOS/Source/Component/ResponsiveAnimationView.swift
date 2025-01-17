//
//  ResponsiveAnimationView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/17/25.
//

import SwiftUI

struct ResponsiveAnimationView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 50) {
                    Text("Responsive Animation")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.green)
                        .frame(
                            width: geometry.size.width * 0.8,
                            height: animate ? geometry.size.height * 0.3 : geometry.size.height * 0.2
                        )
                        .shadow(color: .green.opacity(0.7), radius: 20)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                animate.toggle()
                            }
                        }
                }
            }
        }
    }
}

struct ResponsiveAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ResponsiveAnimationView()
    }
}
