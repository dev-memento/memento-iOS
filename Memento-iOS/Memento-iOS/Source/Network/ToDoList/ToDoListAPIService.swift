//
//  ToDoListAPIService.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/23/25.
//

import Foundation
import Moya

// MARK: - ToDoListAPIServiceProtocol

protocol ToDoListAPIServiceProtocol {
    func getToDoListTotal(completion: @escaping (NetworkResult<ToDoListTotalResponseDTO>) -> Void)
    func getToDoByDate(date: String, completion: @escaping (NetworkResult<ToDoByDateResponseDTO>) -> Void)
    func getToDoDetail(toDoId: Int, completion: @escaping (NetworkResult<ToDoDetailResponseDTO>) -> Void)
    
    func postToDo(body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func deleteToDo(toDoId: Int, completion: @escaping (NetworkResult<Void>) -> Void)
    
    func updateToDo(toDoId: Int, body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void)
    func updateToDoCompletion(toDoId: Int, completion: @escaping (NetworkResult<ToDoCompletionResponseDTO>) -> Void)
}

extension ToDoListAPIServiceProtocol {
    typealias ToDoListTotalResponseDTO = BaseDTO<ToDoListTotalResponse>
    typealias ToDoByDateResponseDTO = BaseDTO<ToDoListTotalResponse> // 전체 투두 조회랑 같은 DTO
    typealias ToDoDetailResponseDTO = BaseDTO<ToDoDetailResponse>
    
    typealias ToDoCompletionResponseDTO = BaseDTO<ToDoCompletionResponse>
}

// MARK: - ToDoListAPIService
// TODO: 공통 헬퍼 함수로 묶어서 중복 코드 제거

final class ToDoListAPIService: BaseAPIService, ToDoListAPIServiceProtocol {
    
    private let provider = MoyaProvider<ToDoListTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]                    
    )
    
    // 전체 투두리스트 조회
    func getToDoListTotal(completion: @escaping (NetworkResult<ToDoListTotalResponseDTO>) -> Void) {
        provider.request(.getToDoListTotal) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ToDoListTotalResponseDTO>
            
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
    
    // 특정 날짜 투두 조회
    func getToDoByDate(date: String, completion: @escaping (NetworkResult<ToDoByDateResponseDTO>) -> Void) {
        provider.request(.getToDoByDate(date: date)) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ToDoByDateResponseDTO>
            
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
    
    // 투두 상세 조회
    func getToDoDetail(toDoId: Int, completion: @escaping (NetworkResult<ToDoDetailResponseDTO>) -> Void) {
        provider.request(.getToDoDetail(toDoId: toDoId)) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ToDoDetailResponseDTO>
            
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
    
    // 투두 생성
    func postToDo(body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.postToDo(body: body)) { [weak self] result in
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
    
    // 투두 삭제
    func deleteToDo(toDoId: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.deleteToDo(todoId: toDoId)) { [weak self] result in
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
    
    // 투두 수정
    func updateToDo(toDoId: Int, body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.request(.updateToDo(todoId: toDoId)) { [weak self] result in
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
    
    // 투두 완료 업데이트
    func updateToDoCompletion(toDoId: Int, completion: @escaping (NetworkResult<ToDoCompletionResponseDTO>) -> Void) {
        provider.request(.updateToDoCompletion(toDoId: toDoId)) { [weak self] result in
            guard let self = self else { return }
            let networkResult: NetworkResult<ToDoCompletionResponseDTO>
            
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
}
