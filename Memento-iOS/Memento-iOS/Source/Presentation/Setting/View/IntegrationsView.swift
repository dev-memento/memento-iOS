//
//  IntegrationsView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import SwiftUI
import MDSKit

struct IntegrationsView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack{
            CustomNavigationBar(
                title: "Integrations",
                showBackButton: true,
                showSkipButton: false,
                backButtonAction: {
                    viewModel.navigateBack()
                }
            )
            .padding(.top, 25)
            
            
            ConnectedCalendarView()
                .padding(.top, 25)
                .padding(.bottom, 26)
            
            CalendarConnectButtons()
            
            Spacer()
        }
    }
}


private struct ConnectedCalendarView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Connected")
                    .applyFont(.detail_r_12)
                    .foregroundColor(Color.gray05)
                
                Spacer()
            }
            .padding(.horizontal, 36)
            
            Button {
                // 구글 캘린더 연동 버튼 동작
            } label: {
                HStack(spacing: 0) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 8)
                    
                    Text("Apple Calendar")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray03)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.gray10)
                .cornerRadius(4)
            }
            .padding(.horizontal, 34)       // 버튼 주변에 패딩 적용
            
        }
        .background {
            RoundedRectangle(cornerRadius: 4)
                           .fill(Color.gray09)
                           .frame(height: 89)
                           .padding(.horizontal,20)
        }
    }
}

private struct CalendarConnectButtons: View {
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Add")
                    .applyFont(.detail_r_12)
                    .foregroundColor(Color.gray05)
                
                Spacer()
            }
            .padding(.horizontal, 36)
            
            Button {
                // 구글 캘린더 연동 버튼 동작
            } label: {
                HStack(spacing: 0) {
                    Image(.img_google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 8)
                    
                    Text("Google Calendar")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray03)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .background(Color.gray10)
                .cornerRadius(4)
            }
            .padding(.horizontal, 34)
            
            
            Button {
                // 구글 캘린더 연동 버튼 동작
            } label: {
                HStack(spacing: 0) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 8)
                    
                    Text("Apple Calendar")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray03)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.gray10)
                .cornerRadius(4)
            }
            .padding(.horizontal, 34)       // 버튼 주변에 패딩 적용
            
        }
    }
}

#Preview {
    IntegrationsView()
}
