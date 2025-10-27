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

final class ToDoListAPIService: BaseAPIService, ToDoListAPIServiceProtocol {
    
    private let provider = MoyaProvider<ToDoListTargetType>(
        session: AFSessionFactory.shared,
        plugins: [MoyaPlugin.shared]
    )
    
    // 공통 요청 처리 메서드 (응답 데이터 있는 경우)
    private func request<T: Decodable>(
        _ target: ToDoListTargetType,
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
        _ target: ToDoListTargetType,
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
    
    // 전체 투두리스트 조회
    func getToDoListTotal(completion: @escaping (NetworkResult<ToDoListTotalResponseDTO>) -> Void) {
        request(.getToDoListTotal, completion: completion)
    }
    
    // 특정 날짜 투두 조회
    func getToDoByDate(date: String, completion: @escaping (NetworkResult<ToDoByDateResponseDTO>) -> Void) {
        request(.getToDoByDate(date: date), completion: completion)
    }
    
    // 투두 상세 조회
    func getToDoDetail(toDoId: Int, completion: @escaping (NetworkResult<ToDoDetailResponseDTO>) -> Void) {
        request(.getToDoDetail(toDoId: toDoId), completion: completion)
    }
    
    // 투두 생성
    func postToDo(body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.postToDo(body: body), completion: completion)
    }
    
    // 투두 삭제
    func deleteToDo(toDoId: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.deleteToDo(todoId: toDoId), completion: completion)
    }
    
    // 투두 수정
    func updateToDo(toDoId: Int, body: ToDoPostRequest, completion: @escaping (NetworkResult<Void>) -> Void) {
        requestWithoutResponse(.updateToDo(todoId: toDoId, body: body), completion: completion)
    }
    
    // 투두 완료 업데이트
    func updateToDoCompletion(toDoId: Int, completion: @escaping (NetworkResult<ToDoCompletionResponseDTO>) -> Void) {
        request(.updateToDoCompletion(toDoId: toDoId), completion: completion)
    }
}
