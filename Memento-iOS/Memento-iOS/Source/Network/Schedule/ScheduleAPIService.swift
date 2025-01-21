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
    func getSchedulesAllDays(completion: @escaping (NetworkResult<ScheduleAllDayResponseDTO>) -> Void)
    func getSchedules(completion: @escaping (NetworkResult<ScheduleResponseDTO>) -> Void)
    func getSchedulesDetail(completion: @escaping (NetworkResult<ScheduleDetailResponseDTO>) -> Void)
}

extension ScheduleAPIServiceProtocol {
    typealias ScheduleTotalResponseDTO = BaseDTO<ScheduleTotalResponseData>
    typealias ScheduleAllDayResponseDTO = BaseDTO<ScheduleAllDayResponseData>
    typealias ScheduleResponseDTO = BaseDTO<ScheduleResponseData>
    typealias ScheduleDetailResponseDTO = BaseDTO<ScheduleDetailResponseData>
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
            }
        }
    }
    
    // 일정 All-day API 연결
    func getSchedulesAllDays(completion: @escaping (NetworkResult<ScheduleAllDayResponseDTO>) -> Void) {
        provider.request(.getSchedulesAllDay) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ScheduleAllDayResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
                
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<ScheduleAllDayResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    // 일정 (해당 날짜) API 연결 
    func getSchedules(completion: @escaping (NetworkResult<ScheduleResponseDTO>) -> Void) {
        provider.request(.getSchedules) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ScheduleResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
                
            case.failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<ScheduleResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
    
    // 일정 (디테일) API 연결 
    func getSchedulesDetail(completion: @escaping (NetworkResult<ScheduleDetailResponseDTO>) -> Void) {
        provider.request(.getSchedulesDetail) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ScheduleDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                print(networkResult.stateDescription)
                completion(networkResult)
                
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<ScheduleDetailResponseDTO> = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                    completion(networkResult)
                }
            }
        }
    }
   
}
