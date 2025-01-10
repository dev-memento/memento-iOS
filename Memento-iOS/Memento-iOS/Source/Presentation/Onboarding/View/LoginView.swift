//
//  LoginView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI

struct LoginView: View {
    @State private var path: [String] = [] // Navigation 경로를 관리하는 배열

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                BackgroundView()
                
                VStack(alignment: .center) {
                    HeaderView()
                        .padding(.top, 115)
                    
                    LoginButtons(path: $path)
                        .padding(.top, 103.2)
                    
                    TermsOfUseView()
                        .padding(.top, 18)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "SleepCycleSettingView" {
                    SleepCycleSettingView(path: $path) 
                        .navigationBarBackButtonHidden()
                } else if destination == "WorkSelectionView" {
                    WorkSelectionView(path: $path)
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

// MARK: - Header View
private struct HeaderView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Less Noise,")
                .font(.system(size: 24)) // 추후 디자인 시스템으로 수정 할 것임
                .foregroundColor(.white) // Text 색상을 흰색으로 변경
            Text("More Progress,")
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Image("MainLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 49.38, height: 43.16)
                .padding(.top, 98.64)
        }
    }
}

// MARK: - Logo View
private struct LogoView: View {
    var body: some View {
        Image("MainLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 49.38, height: 43.16)
    }
}

// MARK: - Login Buttons
private struct LoginButtons: View {
    @Binding var path: [String] // Navigation 경로를 관리하는 바인딩 변수

    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
                path.append("SleepCycleSettingView") // 경로에 추가
            } label: {
                Image("GoogleLogin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 183, height: 24)
                    .padding(EdgeInsets(top: 11, leading: 76, bottom: 11, trailing: 84))
                    .background(Color("ButtonBackColor"))
            }
            
            Button {
                path.append("SleepCycleSettingView") // 경로에 추가
            } label: {
                Image("AppleLogin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 183, height: 24)
                    .padding(EdgeInsets(top: 11, leading: 76, bottom: 11, trailing: 84))
                    .background(Color("ButtonBackColor"))
            }
        }
    }
}

// MARK: - Terms Of Use View
private struct TermsOfUseView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("by continuing, you agree to memento's")
                .font(.system(size: 11))
                .foregroundColor(Color("gray07"))
            
            Link("Terms of Use", destination: URL(string: "https://www.naver.com")!)
                .font(.system(size: 11))
                .foregroundColor(Color("gray04"))
        }
    }
}

#Preview {
    LoginView()
}
