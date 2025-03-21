//
//  AppState.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        do {
            try TokenKeychainManager.shared.clearTokens()
        } catch {
            
        }
        //checkToken()
    }
    
    func checkToken() {
        do {
            // AccessToken 확인
            if let accessToken = try TokenKeychainManager.shared.getAccessToken(), !accessToken.isEmpty {
                isLoggedIn = true
            } else {
                isLoggedIn = false
            }
        } catch {
            print("토큰 확인 실패: \(error.localizedDescription)")
            isLoggedIn = false
        }
    }
}
