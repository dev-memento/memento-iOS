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
    func fetchWeeklyPrioritization(body: PrioritizationRequest, completion: @escaping (NetworkResult<PrioritizationResponseDTO>) -> Void)
}

extension PrioritizationAPIServiceProtocol {
    typealias PrioritizationResponseDTO = BaseDTO<PrioritizationResponse>
}

// MARK: - PrioritizationAPIService

final class PrioritizationAPIService: BaseAPIService, PrioritizationAPIServiceProtocol {
    
    private let provider = MoyaProvider<PrioritizationTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    func fetchWeeklyPrioritization(body: PrioritizationRequest, completion: @escaping (NetworkResult<PrioritizationResponseDTO>) -> Void) {
        provider.request(.fetchWeeklyPrioritization(body: body)) { [weak self] result in
            guard let self = self else { return }
            
            let networkResult: NetworkResult<PrioritizationResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                } else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
}
