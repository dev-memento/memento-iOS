//
//  CalendarConnectView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/11/25.
//

import SwiftUI
import MDSKit

struct CalendarConnectView: View {
    
    @FocusState private var isTextFieldFocused: Bool
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .center) {
                CustomNavigationBar(path: $path)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                HeaderTitleView()
                    .padding(.horizontal)
                
                CalendarConnectButtons(path: $path)
                    .padding(.top, 133)
                
                Spacer()
                
                NextButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7.5, height: 16.5)
                    .foregroundColor(.gray06)
            }
            Spacer()
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
    var body: some View {
        ZStack {
            // 이미지가 배경으로
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 80)
                .foregroundColor(Color.gray09)
                .opacity(0.5)
                .offset(x:120, y: 40)
            
            VStack(alignment: .center, spacing: 10) {
                Text("Connect your calendar")
                    .applyFont(.title_b_24)
                    .foregroundColor(.white)
                
                Text("for seamless scheduling.")
                    .applyFont(.title_b_24)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

// MARK: - CalendarConnectButtons
private struct CalendarConnectButtons: View {
    @Binding var path: [OnBoardingNavigationDestination] // Navigation 경로를 관리하는 바인딩 변수
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
                //path.append(.sleepCycleSetting)
            } label: {
                HStack(spacing: 8) {
                    Image(.img_google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Connect Google Calendar")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10) // 배경 색상
            
            Button {
                //path.append(.sleepCycleSetting)
            } label: {
                HStack(spacing: 8) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    Text("Connect Apple Calendar")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10) // 배경 색상
            
        }
    }
}

// MARK: - Next Button
private struct NextButton: View {
    
    var body: some View {
        Button {
          
        } label: {
            Text("Start MEMENTO")
                .applyFont(.body_b_16)
                .foregroundColor(Color.black)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(Color.mainGreen)
        .frame(height: 50)
        .cornerRadius(2)
    }
}

#Preview {
    CalendarConnectView(path: .constant([]))
}
