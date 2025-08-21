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
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        registerFonts()
        FirebaseApp.configure()
        Messaging.messaging().isAutoInitEnabled = true
        Messaging.messaging().apnsToken = Data(repeating: 0, count: 32)
        UNUserNotificationCenter.current().delegate = self
        
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        //            if let error = error {
        //                print("알림 권한 요청 실패: \(error.localizedDescription)")
        //                return
        //            }
        //            if granted {
        //                DispatchQueue.main.async {
        //                    UIApplication.shared.registerForRemoteNotifications()
        //                }
        //            } else {
        //                print("알림 권한 거부")
        //            }
        //        }
        
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
    
    @StateObject private var authSession = AuthSession.shared
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State var showLottieAnimation: Bool = true
    @State private var didRunAutoLoginOnce = false
    
    
    var body: some Scene {
        WindowGroup {
            rootView
                .environmentObject(authSession) // 앱 전체에서 사용자 세션 감시 (사용 가능하게)
                .onAppear {
                    guard !didRunAutoLoginOnce else { return }
                    didRunAutoLoginOnce = true
                    Task { authSession.autoLoginOnLaunch() } 
                }
//                .onAppear { // 탈퇴시 로그인 된 탭 화면에서 해당 코드 실행 해야함
//                    Task { await withdrawAndSignOut() }
//                }
        }
    }
    
    @ViewBuilder
    private var rootView: some View {
        if showLottieAnimation {
            SplashScreenView(showLottieAnimation: $showLottieAnimation)
                .preferredColorScheme(.dark)
        } else {
            if authSession.isLoggedIn {
                TabBarView()
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
                    .environmentObject(onboardingViewModel)
                    .preferredColorScheme(.dark)
            }
        }
    }
    
    /// 회원 탈퇴 + 세션/토큰 정리
    private func withdrawAndSignOut() async {
        // (선택) 토큰 없으면 바로 종료
        if (try? TokenKeychainManager.shared.getAccessToken()) == nil {
            print("⚠️ AccessToken 없음: 탈퇴 API 호출 생략")
            return
        }
        
        let service = MemberAPIService() // DELETE /api/v1/members 호출하는 서비스
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            service.withdraw { result in
                switch result {
                case .success:
                    // 토큰/세션 정리
                    print("✅ 회원 탈퇴 완료")
                    try? TokenKeychainManager.shared.clearTokens()
                    GIDSignIn.sharedInstance.signOut()
                    try? Auth.auth().signOut()
                    Task { @MainActor in
                        authSession.isLoggedIn = false
                    }
                case .unAuthorized:
                    print("⚠️ 401 Unauthorized: 토큰 만료/로그인 필요")
                default:
                    print("❌ 회원 탈퇴 실패(서버 오류)")
                }
                cont.resume()
            }
        }
    }
}
