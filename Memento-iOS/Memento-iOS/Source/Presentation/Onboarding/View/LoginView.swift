//
//  LoginView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

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
                .applyFont(.title_b_24)
                .foregroundColor(.white)
            
            Text("More Progress,")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
            
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
                .frame(width: 49.38, height: 43.16)
                .padding(.top, 98.64)
                .foregroundColor(.white)
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
                path.append("SleepCycleSettingView")
            } label: {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 183, height: 24)
                    .padding(EdgeInsets(top: 11, leading: 76, bottom: 11, trailing: 84))
                    .background(Color.gray10)
            }
            
            Button {
                path.append("SleepCycleSettingView")
            } label: {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 183, height: 24)
                    .padding(EdgeInsets(top: 11, leading: 76, bottom: 11, trailing: 84))
                    .background(Color.gray10)
            }
        }
    }
}

// MARK: - Terms Of Use View
private struct TermsOfUseView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("by continuing, you agree to memento's")
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray07)
            
            Link("Terms of Use", destination: URL(string: "https://www.naver.com")!)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray04)
        }
    }
}

#Preview {
    LoginView()
}
