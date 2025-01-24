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
    func getToDoList(completion: @escaping (NetworkResult<BaseDTO<ToDoListTotalResponseData>>) -> Void)
    func getToDoDetail(id: Int, completion: @escaping (NetworkResult<BaseDTO<ToDoListTotalResponseData>>) -> Void)
}

extension ToDoListAPIServiceProtocol {
    typealias ToDoListResponseDTO = BaseDTO<ToDoListTotalResponseData>
}

// MARK: - ToDoListAPIService

final class ToDoListAPIService: BaseAPIService, ToDoListAPIServiceProtocol {
    
    private let provider = MoyaProvider<ToDoListTargetType>(plugins: [MoyaPlugin.shared])
    
    // To-Do List API 연결
    func getToDoList(completion: @escaping (NetworkResult<BaseDTO<ToDoListTotalResponseData>>) -> Void) {
        provider.request(.getToDoList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<ToDoListTotalResponseData>> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                print(networkResult.stateDescription)
                completion(networkResult)
            case .failure(let error):
                if let response = error.response {
                    let networkResult: NetworkResult<BaseDTO<ToDoListTotalResponseData>> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    completion(networkResult)
                }
            }
        }
    }
    
    func getToDoDetail(id: Int, completion: @escaping (NetworkResult<BaseDTO<ToDoListTotalResponseData>>) -> Void) {
        provider.request(.getToDoDetail(id: id)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<BaseDTO<ToDoListTotalResponseData>> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
