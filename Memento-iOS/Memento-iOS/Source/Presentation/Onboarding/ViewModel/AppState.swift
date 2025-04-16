//
//  AppState.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation

class AppState: ObservableObject {

    static let shared = AppState()

    @Published var isLoggedIn: Bool = false
    
    init() {
        checkToken()
    }
    
    func checkToken() {
        do {
            // AccessToken 확인
            if let accessToken = try TokenKeychainManager.shared.getAccessToken(), !accessToken.isEmpty {
                debugPrintTokenPayload(accessToken)
                isLoggedIn = true
            } else {
                isLoggedIn = false
            }
        } catch {
            print("DEBUG: 토큰 확인 실패 >>> \(error.localizedDescription)")
            isLoggedIn = false
        }
    }
}

private extension AppState {

    /// JWT 토큰의 Payload를 디코딩하여 콘솔에 디버깅 출력합니다.
    ///
    /// 이 함수는 전달된 JWT 문자열을 파싱하여 payload 부분(base64 인코딩된 JSON)을 추출하고,
    /// 이를 디코딩하여 Payload 내부의 key-value 구조를 콘솔에 출력합니다.
    ///
    /// `exp` 필드가 존재할 경우, 해당 만료 시간을 Date로 변환하여 사람이 읽을 수 있는 형식으로 함께 출력합니다.
    ///
    /// - Parameter token: JWT 형식의 액세스 토큰 문자열 (`header.payload.signature` 형식)
    ///
    /// - Note:
    ///    - JWT는 3개의 base64 인코딩된 문자열로 구성되어야 하며, payload는 JSON 구조여야 합니다.
    ///    - payload는 base64 URL-safe 포맷이기 때문에 `=` 패딩이 누락될 수 있으며,
    ///      이를 보정하기 위해 `base64Padded()`를 사용합니다.
    ///
    /// - Warning:
    ///    - `token`이 올바르지 않은 형식이거나 payload 디코딩에 실패할 경우,
    ///      적절한 디버깅 메시지가 출력되며 함수는 조용히 종료됩니다.
    ///
    /// - Example:
    /// ```swift
    /// let token = "eyJhbGci~.eyJzdWIiOi~.SflKxwRJSMeKK~V_adQ~"
    /// debugPrintTokenPayload(token)
    /// ```
    ///
    /// - Output:
    /// ```
    /// DEBUG: JWT Payload >>>
    /// DEBUG: - iat: 1744269500
    /// DEBUG: - exp: 1744206900
    /// DEBUG: - sub: 123
    /// DEBUG: exp 존재함 >>> 1744206900.0 (2025-04-10 17:35:00)
    /// ```
    func debugPrintTokenPayload(_ token: String) {
        let parts = token.split(separator: ".")

        guard parts.count == 3 else {
            print("DEBUG: JWT 구조가 올바르지 않습니다.")
            return
        }

        let payloadBase64 = String(parts[1]).base64Padded()

        guard let payloadData = Data(base64Encoded: payloadBase64) else {
            print("DEBUG: payload base64 디코딩 실패")
            return
        }

        guard let jsonObject = try? JSONSerialization.jsonObject(with: payloadData),
              let json = jsonObject as? [String: Any] else {
            print("DEBUG: payload JSON 파싱 실패")
            return
        }

        print("DEBUG: JWT Payload >>>")
        for (key, value) in json {
            print("DEBUG: - \(key): \(value)")
        }

        if let exp = json["exp"] as? TimeInterval {
            let date = Date(timeIntervalSince1970: exp)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = .current

            print("DEBUG: exp 존재함 >>> \(exp) (\(formatter.string(from: date)))")
        } else {
            print("DEBUG: exp 필드 없음")
        }
    }
}
