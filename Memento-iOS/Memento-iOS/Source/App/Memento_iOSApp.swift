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
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // FCM 메시징 델리게이트 지정
        Messaging.messaging().delegate = self
        
        // 알림 센터 델리게이트 지정
        UNUserNotificationCenter.current().delegate = self
        
        // 실행 시마다 권한 상태 점검 & 요청
        checkAndRequestPushPermission()
        
        
        return true
    }
    
    // MARK: - 권한 제어 테스트 메서드
    
     private func checkAndRequestPushPermission() {
         UNUserNotificationCenter.current().getNotificationSettings { settings in
             switch settings.authorizationStatus {
                 
             case .notDetermined:
                 // 아직 권한 요청을 안 한 경우 → 권한 요청
                 UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                     if let error = error {
                         print("알림 권한 요청 실패: \(error.localizedDescription)")
                         return
                     }
                     if granted {
                         DispatchQueue.main.async {
                             UIApplication.shared.registerForRemoteNotifications()
                         }
                         print("알림 권한 허용")
                     } else {
                         print("알림 권한 거부 (처음 요청)")
                     }
                 }
                 
             case .denied:
                 // 이미 거부됨 → 설정 화면으로 유도
                 print("알림 권한 거부 상태 → 설정 앱으로 이동 필요")
                 DispatchQueue.main.async {
                     if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                         UIApplication.shared.open(appSettings)
                     }
                 }
                 
             case .authorized, .provisional, .ephemeral:
                 // 이미 허용된 상태 → 바로 APNs 등록
                 DispatchQueue.main.async {
                     UIApplication.shared.registerForRemoteNotifications()
                 }
                 print("이미 알림 권한 있음")
                 
             @unknown default:
                 break
             }
         }
     }
    
    // APNs 등록 성공
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs 디바이스 토큰 등록 성공")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APNs 등록 실패
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 디바이스 토큰 등록 실패: \(error.localizedDescription)")
    }
    
    // FCM 토큰 수신 (최신 방식)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        print("📌 Firebase FCM 등록 토큰: \(token)")
        
        // 👉 서버에 전송 or UserDefaults 저장
        // MyAPIService.shared.updateFCMToken(token)
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
    
    // 외부 앱 (예: 구글 로그인) 콜백 처리
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
                    authSession.autoLoginOnLaunch()
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
