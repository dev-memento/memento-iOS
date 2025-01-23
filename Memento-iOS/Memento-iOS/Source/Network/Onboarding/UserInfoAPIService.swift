//
//  UserInfoAPIServiceProtocol.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

// MARK: - UserInfoAPIServiceProtocol
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
    func updateUserInfo(request: UserInfoRequest, completion: @escaping (NetworkResult<BaseDTO<[String: String]>>) -> Void)
}

extension UserInfoAPIServiceProtocol {
    typealias EmptyDTO = BaseDTO<[String: String]>
}

// MARK: - UserInfoAPIService

final class UserInfoAPIService: BaseAPIService, UserInfoAPIServiceProtocol {
    private let provider = MoyaProvider<UserInfoTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin()])

    /// 사용자 정보 업데이트 API 호출
    func updateUserInfo(request: UserInfoRequest, completion: @escaping (NetworkResult<BaseDTO<[String: String]>>) -> Void) {
        provider.request(.user(request: request)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<[String: String]>> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)

            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<[String: String]>> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                } else {
                    completion(.networkFail)
                }
            }
        }
    }
}
