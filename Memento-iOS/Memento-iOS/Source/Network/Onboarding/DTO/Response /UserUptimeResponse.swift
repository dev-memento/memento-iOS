//
//  UserUptimeResponse.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation

struct UserUptimeResponse: Codable {
    let wakeUpTime: String
    let windDownTime: String
}
