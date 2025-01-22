//
//  NewAccessTokenResponse.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation

struct NewAccessTokenResponse: Codable {
    struct Data: Codable {
        let accessToken: String
        let refreshToken: String
    }
    let data: Data
}

