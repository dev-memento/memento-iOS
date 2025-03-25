//
//  NewAccessTokenResponse.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/22/25.
//

import Foundation

struct NewAccessTokenResponse: Decodable {
    let message: String
    let data: TokenData
}

struct TokenData: Decodable {
    let accessToken: String
    let refreshToken: String
}
