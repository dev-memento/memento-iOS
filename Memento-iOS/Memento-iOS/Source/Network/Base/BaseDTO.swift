//
//  BaseDTO.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/6/25.
//

import Foundation

// TODO: - API 명세서 나오면 변경

/// data가 들어있을 때 Base Model
struct BaseDTO<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T
}

/// data가 비었을 경우에 사용
struct EmptyDTO: Codable {
    let code: Int
    let message: String
    let data: [String: String]?
}
