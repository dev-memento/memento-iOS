//
//  Memento_iOSApp.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import SwiftUI

import FirebaseCore
import GoogleSignIn
import MDSKit

import Firebase
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        registerFonts()
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("알림 권한 거부")
            }
        }

        Thread.sleep(forTimeInterval: 2)
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs 디바이스 토큰 등록 성공")
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 디바이스 토큰 등록 실패: \(error.localizedDescription)")
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MementoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var onboardingViewModel = OnboardingViewModel(authViewModel: AuthViewModel())
    @StateObject private var appState = AppState.shared
    @State var showLottieAnimation: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if showLottieAnimation {
                SplashScreenView(showLottieAnimation: $showLottieAnimation)
                    .preferredColorScheme(.dark)
            } else {
                if appState.isLoggedIn {
                    TabBarView()
                        .preferredColorScheme(.dark)
                } else {
                    LoginView()
                        .environmentObject(onboardingViewModel)
                        .preferredColorScheme(.dark)
                }
            }
        }
    }
}
