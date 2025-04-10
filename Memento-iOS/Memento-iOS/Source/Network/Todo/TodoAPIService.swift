//
//  TodoAPIService.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import Foundation

import Moya

protocol TodoAPIServiceProtocol {
    func deleteTodo(todoId: Int, completion: @escaping (NetworkResult<Void>) -> Void)
    func createTodo(
        startDate: String,
        description: String,
        endDate: String?,
        tagId: Int?,
        priorityUrgency: Double?,
        priorityImportance: Double?,
        completion: @escaping (NetworkResult<Void>) -> Void
    )
}

final class TodoAPIService: BaseAPIService, TodoAPIServiceProtocol {

    private let provider = MoyaProvider<TodoTargetType>(plugins: [MoyaPlugin.shared, TokenRefreshPlugin.shared])

    func deleteTodo(todoId: Int, completion: @escaping (NetworkResult<Void>) -> Void) {
        provider.requestWithTokenRefresh(.deleteTodo(todoId: todoId)) { result in
            print("DEBUG: Requesting DELETE for Todo ID: \(todoId)")
            switch result {
            case .success(let response):
                let result: NetworkResult<Void> = self.fetchNetworkResult(
                    statusCode: response.statusCode
                )
                print("DEBUG: \(result.stateDescription)")
                completion(result)
            case .failure(let error):
                if let response = error.response {
                    let result: NetworkResult<Void> = self.fetchNetworkResult(
                        statusCode: response.statusCode
                    )
                    print("DEBUG: \(result.stateDescription)")
                    completion(result)
                }
            }
        }
    }

    func createTodo(
        startDate: String,
        description: String,
        endDate: String?,
        tagId: Int?,
        priorityUrgency: Double?,
        priorityImportance: Double?,
        completion: @escaping (NetworkResult<Void>) -> Void
    ) {
        provider.requestWithTokenRefresh(
            .createTodo(
                startDate: startDate,
                description: description,
                endDate: endDate,
                tagId: tagId,
                priorityUrgency: priorityUrgency,
                priorityImportance: priorityImportance
            )
        ) { result in
            switch result {
            case .success(let response):
                let result: NetworkResult<Void> = self.fetchNetworkResult(
                    statusCode: response.statusCode
                )
                print("DEBUG: \(result.stateDescription)")
                completion(result)
            case .failure(let error):
                if let response = error.response {
                    let result: NetworkResult<Void> = self.fetchNetworkResult(
                        statusCode: response.statusCode
                    )
                    print("DEBUG: \(result.stateDescription)")
                    completion(result)
                }
            }
        }
    }
}
