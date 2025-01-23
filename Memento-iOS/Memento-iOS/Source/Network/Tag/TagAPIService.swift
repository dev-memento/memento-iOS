//
//  TagAPIService.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/23/25.
//

import Foundation

import Moya

// MARK: - TagAPIServiceProtocol

protocol TagAPIServiceProtocol {

}

extension TagAPIServiceProtocol {

}

// MARK: - TagAPIService

final class TagAPIService: BaseAPIService, TagAPIServiceProtocol {

    private let provider = MoyaProvider<ScheduleTargetType>(plugins: [MoyaPlugin.shared])
    
}
