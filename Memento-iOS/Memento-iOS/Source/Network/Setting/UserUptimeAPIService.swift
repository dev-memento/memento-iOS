//
//  UserUptimeAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

// MARK: - UserUptimeAPIServiceProtocol

protocol UserUptimeAPIServiceProtocol {
    func getUserUptime(completion: @escaping (NetworkResult<UserUptimeResponseDTO>) -> Void)
    func updateUserUptime(body: UserUptimeRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
    func updateUserTimezone(body: UserTimezoneRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
}

extension UserUptimeAPIServiceProtocol {
    typealias UserUptimeResponseDTO = BaseDTO<UserUptimeResponse>
}

// MARK: - UserUptimeAPIService

final class UserUptimeAPIService: BaseAPIService, UserUptimeAPIServiceProtocol {
    private let provider = MoyaProvider<UserUptimeTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    func getUserUptime(completion: @escaping (NetworkResult<UserUptimeResponseDTO>) -> Void) {
        provider.request(.getUserUptime) { [weak self] result in
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
    
    func updateUserUptime(body: UserUptimeRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.updateUserUptime(body: body)) { [weak self] result in
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
    
    func updateUserTimezone(body: UserTimezoneRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.updateUserTimezone(body: body)) { [weak self] result in
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
