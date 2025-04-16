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

extension UserUptimeAPIServiceProtocol {
    typealias UserUptimeResponseDTO = BaseDTO<UserUptimeResponse>
}

// MARK: - UserInfoGetAPIService

final class UserUptimeAPIService: BaseAPIService, UserUptimeAPIServiceProtocol {
    private let provider = MoyaProvider<UserInfoTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin.shared])

    func fetchUptime(completion: @escaping (NetworkResult<UserUptimeResponseDTO>) -> Void) {
        provider.requestWithTokenRefresh(.getUserUptime) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<UserUptimeResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<UserUptimeResponseDTO> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
}
