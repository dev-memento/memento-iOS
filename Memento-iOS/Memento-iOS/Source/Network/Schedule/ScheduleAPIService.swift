//
//  ScheduleAPIService.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/21/25.
//

import Foundation

import Moya

// MARK: - ScheduleAPIServiceProtocol

protocol ScheduleAPIServiceProtocol {
    func getSchedulesTotal(completion: @escaping (NetworkResult<ScheduleTotalResponseDTO>) -> Void)
}

extension ScheduleAPIServiceProtocol {
    typealias ScheduleTotalResponseDTO = BaseDTO<ScheduleTotalResponseData>
}

// MARK: - ScheduleAPIService

final class ScheduleAPIService: BaseAPIService, ScheduleAPIServiceProtocol {

    private let provider = MoyaProvider<ScheduleTargetType>(plugins: [MoyaPlugin.shared])
    
    // 일정(Schedule) 관련 전체 데이터 
    func getSchedulesTotal(completion: @escaping (NetworkResult<ScheduleTotalResponseDTO>) -> Void) {
        provider.request(.getSchedulesTotal) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ScheduleTotalResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<ScheduleTotalResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }}
    }
}
