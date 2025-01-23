//
//  UserInfoGetAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

// MARK: - UserInfoGetAPIServiceProtocol

protocol UserUptimeAPIServiceProtocol {
    func fetchUptime(completion: @escaping (NetworkResult<BaseDTO<UserUptimeResponse>>) -> Void)
}

// MARK: - UserInfoGetAPIService

final class UserUptimeAPIService: BaseAPIService, UserUptimeAPIServiceProtocol {
    private let provider = MoyaProvider<UserUptimeTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin()])

    func fetchUptime(completion: @escaping (NetworkResult<BaseDTO<UserUptimeResponse>>) -> Void) {
        provider.request(.user) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<UserUptimeResponse>> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<UserUptimeResponse>> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
}
