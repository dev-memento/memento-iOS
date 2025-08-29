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
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    CustomNavigationBar(
                        title: SettingsSettingViewText.navigationTitle,
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
                .background(Color.black)
                .navigationDestination(for: SettingNavigationDestination.self) { destination in
                    switch destination {
                    case .Tag:
                        TagEditView()
                            .navigationBarBackButtonHidden()
                    case .TagDetail(let tag, let isNew):
                        TagEditDetailView(tag: tag, isNew: isNew)
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden()
                    case .Time:
                        TimeView()
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden()
                    case .Terms:
                        EmptyView()
                        
                    case .Feedback:
                        EmptyView()
                    }
                }
            }
            .onAppear {
                viewModel.refreshNotificationStatus()
            }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    viewModel.refreshNotificationStatus()
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
                
                Text(verbatim: "memento@gmail.com")
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray04)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
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
                    Text(SettingsSettingViewText.notifications)
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                    
                    NotificationSettingsSection()
                }
                .padding(.horizontal, 26)
                .padding(.top, 16)
                
                SettingsRowButton(
                    title: SettingsSettingViewText.tag,
                    action: { viewModel.navigateToNext(.Tag) }
                )
                
                SettingsRowButton(
                    title: SettingsSettingViewText.time,
                    action: { viewModel.navigateToNext(.Time) }
                )
                
                SettingsRowDivider()
            }
        }
    }
    
    struct NotificationSettingsSection: View {
        @EnvironmentObject var viewModel: SettingViewModel
        
        var body: some View {
            Button {
                viewModel.openAppSettings()
            } label: {
                Image(viewModel.isNotificationEnabled ? .btn_setting_on : .btn_setting_off)
            }
        }
    }
    
    struct AdditionalSettingsSection: View {
        @EnvironmentObject var viewModel: SettingViewModel
        
        var body: some View {
            VStack {
                SettingsRowButton(
                    title: SettingsSettingViewText.feedback,
                    action: { viewModel.navigateToNext(.Feedback) }
                )
                
                SettingsRowButton(
                    title: SettingsSettingViewText.terms,
                    action: { viewModel.navigateToNext(.Terms) }
                )
                
                SettingsRowDivider()
            }
        }
    }
    
    struct AccountSettingsSection: View {
        @EnvironmentObject var authSession: AuthSession
        
        var body: some View {
            VStack {
                HStack {
                    Button {
                        authSession.logout()
                    } label: {
                        Text(SettingsSettingViewText.logout)
                            .applyFont(.body_r_14)
                            .foregroundColor(Color.mementoRed)
                    }
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 26)
                
                HStack {
                    Button {
                        Task {
                            await authSession.withdraw()
                        }
                    } label: {
                        Text(SettingsSettingViewText.deleteAccount)
                            .applyFont(.body_r_14)
                            .foregroundColor(Color.mementoRed)
                    }
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 26)
            }
        }
    }
}

struct SettingsRowButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray05)
                
                Spacer()
            }
            .padding(.top, 15)
            .padding(.horizontal, 26)
        }
    }
}

struct SettingsRowDivider: View {
    var body: some View {
        Divider().background(Color.gray09)
            .padding(.top, 13)
            .padding(.horizontal, 26)
    }
}

#Preview {
    SettingView()
}
