//
//  NewAccessTokenResponse.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation

struct NewAccessTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}


