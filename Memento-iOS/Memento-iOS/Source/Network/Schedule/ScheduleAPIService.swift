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
    func getSchedulesAllDay(completion: @escaping (NetworkResult<ScheduleAllDayResponseDTO>) -> Void)
    func getSchedulesByDate(date: String, completion: @escaping (NetworkResult<ScheduleByDateResponseDTO>) -> Void)
    
    func postSchedule(body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func deleteSchedule(scheduleId: Int, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func updateSchedule(scheduleId: Int, body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
}

extension ScheduleAPIServiceProtocol {
    typealias ScheduleTotalResponseDTO = BaseDTO<ScheduleTotalResponse>
    typealias ScheduleAllDayResponseDTO = BaseDTO<ScheduleAllDayResponse>
    typealias ScheduleByDateResponseDTO = BaseDTO<ScheduleTotalResponse> // 전체 일정 조회랑 같은 DTO
}

// MARK: - ScheduleAPIService

final class ScheduleAPIService: BaseAPIService, ScheduleAPIServiceProtocol {
    
    private let provider = MoyaProvider<ScheduleTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    // 공통 요청 처리 메서드 (응답 데이터 있는 경우)
    private func request<T: Decodable>(
        _ target: ScheduleTargetType,
        completion: @escaping (NetworkResult<T>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            let networkResult: NetworkResult<T>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                } else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    // 공통 요청 처리 메서드 (응답 데이터 필요 없는 경우)
    private func requestWithoutResponse(
        _ target: ScheduleTargetType,
        completion: @escaping (NetworkResult<Void>) -> Void
    ) {
        provider.request(target) { [weak self] result in
            guard let self else { return }
            let networkResult: NetworkResult<Void>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode)
                } else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    func getSchedulesTotal(completion: @escaping (NetworkResult<ScheduleTotalResponseDTO>) -> Void) {
        request(.getSchedulesTotal, completion: completion)
    }
    
    func getSchedulesAllDay(completion: @escaping (NetworkResult<ScheduleAllDayResponseDTO>) -> Void) {
        request(.getSchedulesAllDay, completion: completion)
    }
    
    func getSchedulesByDate(date: String, completion: @escaping (NetworkResult<ScheduleByDateResponseDTO>) -> Void) {
        request(.getSchedulesByDate(date: date), completion: completion)
    }
    
    func postSchedule(body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.postSchedule(body: body), completion: completion)
    }
    
    func deleteSchedule(scheduleId: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.deleteSchedule(scheduleId: scheduleId), completion: completion)
    }
    
    func updateSchedule(scheduleId: Int, body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.updateSchedule(scheduleId: scheduleId, body: body), completion: completion)
    }
}
