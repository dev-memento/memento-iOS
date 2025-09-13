//
//  AppleSchedulesAPIService.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/23/25.
//

import Foundation
import Moya

// MARK: - AppleSchedulesAPIServiceProtocol

protocol AppleSchedulesAPIServiceProtocol {
    func submitSchedules(request: AppleScheduleListRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void)
}

// MARK: - AppleSchedulesAPIService

final class AppleSchedulesAPIService: BaseAPIService, AppleSchedulesAPIServiceProtocol {
    private let provider = MoyaProvider<AppleSchedulesTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    /// 스케줄 생성하기 API 호출
    func submitSchedules(request: AppleScheduleListRequest, completion: @escaping (NetworkResult<EmptyDTO>) -> Void) {
        provider.request(.schedule(request: request)) { [weak self] result in
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
