//
//  AuthSession+Network.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/21/25.
//

import Foundation

import FirebaseMessaging

@MainActor
extension AuthSession {
    
    /// 서버 로그인 공통 메서드
    /// 첫 로그인 토큰 저장 로직 여기에 위치함
     func requestLogin(provider: String, idToken: String) async {
        do {
            let fcmToken = try await Messaging.messaging().token()
            let timeZoneOffset = Self.currentTimeZoneOffset()

            memberService.socialLogin(
                provider: provider,
                idToken: idToken,
                timeZoneOffset: timeZoneOffset,
                fcmToken: fcmToken
            ) { [weak self] result in
                Task { @MainActor in
                    guard let self else { return }
                    switch result {
                    case .success(let resp):
                        guard let data = resp?.data else {
                            self.errorMessage = "로그인 응답 오류"
                            self.isLoading = false
                            return
                        }

                        self.setTokens(accessToken: data.accessToken, refreshToken: data.refreshToken)

                        if data.isNewUser {
                            self.shouldStartOnboarding = true
                            self.isLoggedIn = false
                        } else {
                            self.shouldStartOnboarding = false
                            self.isLoggedIn = true
                        }
                        self.isLoading = false

                    case .unAuthorized:
                        self.errorMessage = "인증 실패. 다시 로그인하세요."
                        self.isLoading = false

                    default:
                        self.errorMessage = "서버 오류가 발생했습니다."
                        self.isLoading = false
                    }
                }
            }
        } catch {
            handleError(error, defaultMessage: "FCM 토큰을 가져올 수 없습니다.")
        }
    }
    
    
    func setTokens(accessToken: String, refreshToken: String) {
        let acc = accessToken.replacingOccurrences(of: "Bearer ", with: "")
        let ref = refreshToken.replacingOccurrences(of: "Bearer ", with: "")
        do {
            try keychain.saveAccessToken(acc)
            try keychain.saveRefreshToken(ref)
            isLoggedIn = keychain.hasValidToken()
        } catch {
            print("[AuthSession] token persist failed: \(error)")
            isLoggedIn = false
            errorMessage = "토큰 저장에 실패했습니다."
        }
    }
    
    static func currentTimeZoneOffset() -> String {
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds / 3600
        let minutes = abs(seconds / 60 % 60)
        return String(format: "%+03d:%02d", hours, minutes)
    }
}
