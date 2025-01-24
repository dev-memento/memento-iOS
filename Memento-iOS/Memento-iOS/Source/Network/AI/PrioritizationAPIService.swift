//
//  PrioritizationAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/24/25.
//

import Foundation
import Moya

// MARK: - PrioritizationAPIServiceProtocol

protocol PrioritizationAPIServiceProtocol {
    func fetchPrioritization(request: PrioritizationRequest, completion: @escaping (NetworkResult<PrioritizationResponse>) -> Void)
}

extension PrioritizationAPIServiceProtocol {
    typealias PrioritizationResponseDTO = BaseDTO<PrioritizationResponse>
}

// MARK: - PrioritizationAPIService

final class PrioritizationAPIService: BaseAPIService, PrioritizationAPIServiceProtocol {
    private let provider = MoyaProvider<PrioritizationTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin()])

    func fetchPrioritization(request: PrioritizationRequest, completion: @escaping (NetworkResult<PrioritizationResponse>) -> Void) {
        provider.request(.todo(request: request)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                let networkResult: NetworkResult<PrioritizationResponse> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<PrioritizationResponse> = self.fetchNetworkResult(
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
