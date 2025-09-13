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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        registerFonts()
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // FCM 메시징 델리게이트 지정
        Messaging.messaging().delegate = self
        
        // 알림 센터 델리게이트 지정
        UNUserNotificationCenter.current().delegate = self
        
        // 권한 여부와 무관하게 항상 APNs 등록 요청
        UIApplication.shared.registerForRemoteNotifications()
        
        // 권한 요청 팝업 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
                return
            }
            print("알림 권한 상태: \(granted ? "허용 ✅" : "거부 ❌")")
        }

        return true
    }
    
    // MARK: - APNs 등록 성공
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📌 APNs 디바이스 토큰 등록 성공: \(tokenString)")
        
        // FCM에 연결
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: - APNs 등록 실패
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("⚠️ APNs 디바이스 토큰 등록 실패: \(error.localizedDescription)")
    }
    
    // MARK: - FCM 토큰 수신 (최신 방식)
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("📌 Firebase FCM 등록 토큰 수신: \(token)")
        
        do {
            let cached = try TokenKeychainManager.shared.getFCMToken()
            
            if cached == token {
                print("기존 FCM 토큰과 동일 → 서버 전송 생략")
            } else {
                try TokenKeychainManager.shared.saveFCMToken(token)
                print("FCM 토큰 저장 완료 & 서버 동기화 필요")
                
                // 서버에 최신 FCM 토큰 전송
            }
            
        } catch {
            // Keychain 조회 실패 → 그냥 새 값 저장
            do {
                try TokenKeychainManager.shared.saveFCMToken(token)
                print("📌 FCM 토큰 신규 저장 완료 & 서버 동기화 필요")
                
                // 서버에 최신 FCM 토큰 전송
            } catch {
                print("❌ FCM 토큰 저장 실패: \(error)")
            }
        }
    }
    
    // 필요시 직접 가져오기
    func fetchFCMTokenManually() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ FCM 토큰 가져오기 실패: \(error.localizedDescription)")
            } else if let token = token {
                print("📌 수동으로 가져온 FCM 토큰: \(token)")
            }
        }
    }
    
    // MARK: - 외부 앱 콜백 처리 (예: 구글 로그인)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct MementoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authSession = AuthSession.shared
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @State var showLottieAnimation: Bool = true
    
    var body: some Scene {
        WindowGroup {
            rootView
                .environmentObject(authSession) // 앱 전체에서 사용자 세션 감시 (사용 가능하게)
                .task {
                    authSession.autoLoginOnLaunch()
                }
            //.onAppear { // 탈퇴시 로그인 된 탭 화면에서 해당 코드 실행 해야함
            //    Task { await authSession.withdraw() }
            //}
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
}
