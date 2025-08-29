//
//  UserInfoUpdateAPIService.swift
//  Memento-iOS
//
//  Created by jeonguk29 on 8/29/25.
//

import Foundation

import Foundation
import Moya

// MARK: - UserInfoUpdateAPIServiceProtocol

protocol UserInfoUpdateAPIServiceProtocol {
    func updateUserUptime(request: UserUptimeRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
    func updateUserTimezone(request: UserTimezoneRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
}

// MARK: - UserInfoUpdateAPIService

final class UserInfoUpdateAPIService: BaseAPIService, UserInfoUpdateAPIServiceProtocol {

    private let provider = MoyaProvider<UserInfoTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    func updateUserUptime(request: UserUptimeRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(UserInfoTargetType.updateUserUptime(request: request)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)

            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
    
    func updateUserTimezone(request: UserTimezoneRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(UserInfoTargetType.updateUserTimezone(request: request)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)

            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<EmptyDTO> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
}
