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
    func getSchedulesDetail(scheduleId: Int, completion: @escaping (NetworkResult<ScheduleDetailResponseDTO>) -> Void)
    
    func postSchedule(body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func deleteSchedule(scheduleId: Int, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func updateSchedule(scheduleId: Int, body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
}

extension ScheduleAPIServiceProtocol {
    typealias ScheduleTotalResponseDTO = BaseDTO<ScheduleTotalResponse>
    typealias ScheduleAllDayResponseDTO = BaseDTO<ScheduleAllDayResponse>
    typealias ScheduleByDateResponseDTO = BaseDTO<ScheduleTotalResponse> // 전체 일정 조회랑 같은 DTO
    typealias ScheduleDetailResponseDTO = BaseDTO<ScheduleDetailResponse>
}

// MARK: - ScheduleAPIService
// TODO: 공통 헬퍼 함수로 묶어서 중복 코드 제거

final class ScheduleAPIService: BaseAPIService, ScheduleAPIServiceProtocol {
    
    private let provider = MoyaProvider<ScheduleTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    // 전체 일정 조회
    func getSchedulesTotal(completion: @escaping (NetworkResult<ScheduleTotalResponseDTO>) -> Void) {
        provider.request(.getSchedulesTotal) { [weak self] result in
            guard let self else { return }
            let networkResult: NetworkResult<ScheduleTotalResponseDTO>
            
            switch result {
            case .success(let response):
                networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
            case .failure(let error):
                if let response = error.response {
                    networkResult = self.fetchNetworkResult(statusCode: response.statusCode, data: response.data)
                }
                else {
                    networkResult = .networkFail
                }
            }
            
            print(networkResult.stateDescription)
            completion(networkResult)
        }
    }
    
    // All day 일정 조회
    func getSchedulesAllDay(completion: @escaping (NetworkResult<ScheduleAllDayResponseDTO>) -> Void) {
        provider.request(.getSchedulesAllDay) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ScheduleAllDayResponseDTO>
            
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
    
    // 특정 날짜 일정 조회
    func getSchedulesByDate(date: String, completion: @escaping (NetworkResult<ScheduleByDateResponseDTO>) -> Void) {
        provider.request(.getSchedulesByDate(date: date)) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ScheduleByDateResponseDTO>
            
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
    
    // 일정 상세 조회
    func getSchedulesDetail(scheduleId: Int, completion: @escaping (NetworkResult<ScheduleDetailResponseDTO>) -> Void) {
        provider.request(.getSchedulesDetail(scheduleId: scheduleId)) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ScheduleDetailResponseDTO>
            
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
    
    // 일정 생성
    func postSchedule(body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.postSchedule(body: body)) { [weak self] result in
            guard let self = self else { return }
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
    
    // 일정 삭제
    func deleteSchedule(scheduleId: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.deleteSchedule(scheduleId: scheduleId)) { [weak self] result in
            guard let self = self else { return }
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
    
    // 일정 수정
    func updateSchedule(scheduleId: Int, body: SchedulePostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.updateSchedule(scheduleId: scheduleId, body: body)) { [weak self] result in
            guard let self = self else { return }
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
}
