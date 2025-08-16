//
//  LoginRequest.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation

struct LoginRequest: Codable {
    let provider: String // "GOOGLE" 또는 "APPLE"
    let idToken: String  // ID Token : From Firebase Auth
    let timeZoneOffset: String 
    let fcmToken: String
}

