//
//  SettingView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 3/21/25.
//

import SwiftUI
import MDSKit

import FirebaseAuth

struct SettingView: View {
    @EnvironmentObject var viewModel: SettingViewModel
    @EnvironmentObject var authSession: AuthSession
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    
    private var userEmail: String {
        Auth.auth().currentUser?.email ?? "이메일 없음"
    }

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        CustomNavigationBar(
                            title: SettingsSettingViewText.navigationTitle,
                            showBackButton: true,
                            showSkipButton: false,
                            backButtonAction: { dismiss() }
                        )
                        .padding(.top, 25)
                        
                        UserInfoCard(userEmail: userEmail)
                        
                        GeneralSettingsSection()
                        
                        AdditionalSettingsSection()
                        
                        AccountSettingsSection(
                            onTapLogout: { showLogoutAlert = true },
                            onTapDelete: { showDeleteAlert = true }
                        )
                        
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
                
                if showLogoutAlert || showDeleteAlert {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture { // 바깥 탭하면 닫기
                            showLogoutAlert = false
                            showDeleteAlert = false
                        }
                }
                
                if showLogoutAlert {
                    CustomAlertView(
                        title: "Do you really want to logout?",
                        message: nil,
                        cancelTitle: "Cancel",
                        confirmTitle: "Logout",
                        confirmAction: {
                            authSession.logout()
                            showLogoutAlert = false
                        },
                        cancelAction: { showLogoutAlert = false }
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale.combined(with: .opacity))
                }
                
                if showDeleteAlert {
                    CustomAlertView(
                        title: "Would you like to delete account?",
                        message: "Permanently delete the account and remove access from all workspaces.",
                        cancelTitle: "Cancel",
                        confirmTitle: "Delete",
                        confirmAction: {
                            Task { await authSession.withdraw() }
                            showDeleteAlert = false
                        },
                        cancelAction: { showDeleteAlert = false }
                    )
                    .padding(.horizontal, 32)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.25), value: showLogoutAlert || showDeleteAlert)
            .onAppear { viewModel.refreshNotificationStatus() }
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    viewModel.refreshNotificationStatus()
                }
            }
        }
    }
    
    struct UserInfoCard: View {
        var userEmail: String
        
        var body: some View {
            HStack(spacing: 15) {
                Image(.img_logo_memento_white)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 44)
                
                Text(verbatim: userEmail)
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
                HStack {
                    Link(SettingsSettingViewText.feedback, destination: URL(string: "https://memento.featurebase.app/en")!)
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 26)
           
                HStack {
                    Link(SettingsSettingViewText.terms, destination: URL(string: "https://memento.today/terms")!)
                        .applyFont(.body_r_14)
                        .foregroundColor(Color.gray05)
                    
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 26)

                SettingsRowDivider()
            }
        }
    }
    
    struct AccountSettingsSection: View {
        let onTapLogout: () -> Void
        let onTapDelete: () -> Void
        
        var body: some View {
            VStack {
                HStack {
                    Button(action: onTapLogout) {
                        Text(SettingsSettingViewText.logout)
                            .applyFont(.body_r_14)
                            .foregroundColor(Color.mementoRed)
                    }
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 26)
                
                HStack {
                    Button(action: onTapDelete) {
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
