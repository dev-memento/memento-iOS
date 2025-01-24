//
//  AddTodoViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/23/25.
//

import SwiftUI

final class AddTodoViewModel: ObservableObject {
    
    @Published var startDate: String = ""
    @Published var description: String = ""
    @Published var endDate: String?
    @Published var tagId: Int?
    @Published var priorityUrgency: Double?
    @Published var priorityImportance: Double?

    private let defaultPriorityValue = 0.0
    private let todoAPIService: TodoAPIServiceProtocol = TodoAPIService()

    func createTodo() {
        todoAPIService.createTodo(
            startDate: startDate,
            description: description,
            endDate: endDate,
            tagId: tagId,
            priorityUrgency: priorityUrgency ?? defaultPriorityValue,
            priorityImportance: priorityImportance ?? defaultPriorityValue
        ) { result in
            switch result {
            case .success(let response):
                guard let response else { return }
                print("DEBUG: Success - \(response)")
            case .badRequest, .notFound:
                print("DEBUG: Error - 잘못된 요청입니다.")
            case .unAuthorized:
                print("DEBUG: Error - 유효하지 않은 토큰입니다.")
            case .serverError:
                print("DEBUG: Error - 내부 서버 에러")
            default:
                print("DEBUG: Error - 에러 발생")
            }
        }
    }
}
