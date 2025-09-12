//
//  UserInfoAPIServiceProtocol.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

// MARK: - UserInfoAPIServiceProtocol

protocol UserInfoAPIServiceProtocol {
    func updateUserInfo(body: UserInfoRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
}

// MARK: - UserInfoAPIService

final class UserInfoAPIService: BaseAPIService, UserInfoAPIServiceProtocol {

    private let provider = MoyaProvider<UserInfoTargetType>(
        session: AFSessionFactory.shared,               
        plugins: [MoyaPlugin.shared]
    )
    
    func updateUserInfo(body: UserInfoRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(UserInfoTargetType.updateUserInfo(body: body)) { [weak self] result in
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

