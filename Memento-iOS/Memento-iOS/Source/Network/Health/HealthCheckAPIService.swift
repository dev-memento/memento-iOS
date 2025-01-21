//
//  HealthCheckAPIService.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/20/25.
//

import Foundation

import Moya

// MARK: - HealthCheckAPIServiceProtocol

protocol HealthCheckAPIServiceProtocol {
    func getHealthCheck(completion: @escaping (NetworkResult<HealthCheckResponseDTO>) -> Void)
}

extension HealthCheckAPIServiceProtocol {
    typealias HealthCheckResponseDTO = BaseDTO<HealthCheckResponseData>
}

// MARK: - HealthCheckAPIService

final class HealthCheckAPIService: BaseAPIService, HealthCheckAPIServiceProtocol {

    private let provider = MoyaProvider<HealthCheckTargetType>(plugins: [MoyaPlugin.shared])

    /// Health Check API 호출
    func getHealthCheck(completion: @escaping (NetworkResult<HealthCheckResponseDTO>) -> Void) {
        provider.request(.getHealthCheck) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<HealthCheckResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<HealthCheckResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
}
