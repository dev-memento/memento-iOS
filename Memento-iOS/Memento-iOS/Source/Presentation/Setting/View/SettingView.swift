//
//  SettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import SwiftUI
import MDSKit

struct SettingView: View {
    var body: some View {
        VStack {
            CustomNavigationBar(
                title: "Sttings",
                showBackButton: true,
                showSkipButton: false,
                backButtonAction: {
                   
                }
            )
            .padding(.top, 25)
            
            UserInfoCard()
            
            GeneralSettingsSection()
            
            AdditionalSettingsSection()
            
            AccountSettingsSection()
            
            Spacer()
            
            
        }
    }
}

struct UserInfoCard: View {
    var body: some View {
        HStack(spacing: 15) {
            Image(.img_logo_memento_white)
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 44)
            
            Text("memento@gmail.com")
                .applyFont(.body_b_14)
                .foregroundColor(Color.gray04)
            
            Spacer()
        }
        .padding(.vertical, 12)  // 상하 패딩 추가
        .padding(.horizontal, 22) // 좌우 패딩 추가
        .background {
            RoundedRectangle(cornerRadius: 4)
                           .fill(Color.gray09)
                           .frame(height: 58)
        }
        .padding(.horizontal, 16)
    }
}

struct GeneralSettingsSection: View {
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(.btn_setting_on)
                }
                
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            
            HStack {
                Text("Tag")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()
                
            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            HStack {
                Text("Time")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()
                
            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            Divider().background(Color.gray09)
                .padding(.top, 13)
                .padding(.horizontal, 26)
        }
    }
}


struct AdditionalSettingsSection: View {
    var body: some View {
        VStack {
            HStack {
                Text("Integrations")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()

            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            Divider().background(Color.gray09)
            .padding(.top, 13)
            .padding(.horizontal, 26)
            
            
            
            HStack {
                Text("Feedback")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()

            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            HStack {
                Text("Terms")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()

            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            
            Divider().background(Color.gray09)
            .padding(.top, 13)
            .padding(.horizontal, 26)
            
        }
    }
}

struct AccountSettingsSection: View {
    var body: some View {
        VStack {
            HStack {
                Text("Logout")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.mementoRed)
                
                Spacer()

            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
            
            HStack {
                Text("Delete My account")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.mementoRed)
                
                Spacer()

            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
        }
    }
}


#Preview {
    SettingView()
}
