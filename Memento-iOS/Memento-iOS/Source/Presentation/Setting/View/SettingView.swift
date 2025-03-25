//
//  SettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import SwiftUI
import MDSKit

struct SettingView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    CustomNavigationBar(
                        title: "Sttings",
                        showBackButton: true,
                        showSkipButton: false,
                        backButtonAction: {
                            dismiss()
                        }
                    )
                    .padding(.top, 25)
                    
                    UserInfoCard()
                    
                    GeneralSettingsSection()
                    
                    AdditionalSettingsSection()
                    
                    AccountSettingsSection()
                    
                    Spacer()
                    
                }
                .navigationDestination(for: SettingNavigationDestination.self) { destination in
                    switch destination {
                    case .Tag:
                        TagEditView()
                            .navigationBarBackButtonHidden()
                    case .Time:
                        TimeView()
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden()
                    case .Integrations:
                        IntegrationsView()
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden()
                    case .Terms:
                        CalendarConnectView()
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden()
                    case .Feedback:
                        EmptyView()
                    }
                }
            }
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
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()
                
                Button {
                    // 알림 설정 버튼 액션
                } label: {
                    Image(.btn_setting_on)
                }
            }
            .padding(.horizontal, 26)
            .padding(.top, 16)
            
            // ✅ Tag 화면으로 이동
            Button {
                viewModel.navigateToNext(.Tag)
            } label: {
                HStack {
                    Text("Tag")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right") // 네비게이션 아이콘 추가
                        .foregroundColor(.gray05)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
            }
            
            // ✅ Time 화면으로 이동
            Button {
                viewModel.navigateToNext(.Time)
            } label: {
                HStack {
                    Text("Time")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray05)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
            }
            
            Divider().background(Color.gray09)
                .padding(.top, 13)
                .padding(.horizontal, 26)
        }
    }
}

struct AdditionalSettingsSection: View {
    @EnvironmentObject var viewModel: SettingViewModel
    
    var body: some View {
        VStack {
            // ✅ Integrations 화면으로 이동
            Button {
                viewModel.navigateToNext(.Integrations)
            } label: {
                HStack {
                    Text("Integrations")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray05)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
            }
            
            Divider().background(Color.gray09)
                .padding(.top, 13)
                .padding(.horizontal, 26)
            
            // ✅ Feedback 화면으로 이동
            Button {
                viewModel.navigateToNext(.Feedback)
            } label: {
                HStack {
                    Text("Feedback")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray05)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
            }
            
            // ✅ Terms 화면으로 이동
            Button {
                viewModel.navigateToNext(.Terms)
            } label: {
                HStack {
                    Text("Terms")
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray05)
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
            }
            
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
