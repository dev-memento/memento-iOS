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
    @Published var tagId: Int? = 1
    @Published var priorityUrgency: Double?
    @Published var priorityImportance: Double?
    @Published var selectedPriority: Priority = .none
    
    private let todoAPIService: TodoAPIServiceProtocol = TodoAPIService()

    func createTodo(completion: @escaping () -> Void) {
        let (priorityUrgency, priorityImportance) = getPriorityValues()

        todoAPIService.createTodo(
            startDate: startDate,
            description: description,
            endDate: startDate,
            tagId: tagId,
            priorityUrgency: priorityUrgency,
            priorityImportance: priorityImportance
        ) { result in
            switch result {
            case .success:
                completion()
                print("DEBUG: Success - 투두 생성 성공")
            case .badRequest, .notFound:
                completion()
                print("DEBUG: Error - 잘못된 요청입니다.")
            case .unAuthorized:
                completion()
                print("DEBUG: Error - 유효하지 않은 토큰입니다.")
            case .serverError:
                completion()
                print("DEBUG: Error - 내부 서버 에러")
            default:
                completion()
                print("DEBUG: Error - 에러 발생")
            }
        }
    }

    private func getPriorityValues() -> (Double, Double) {
        return selectedPriority.getPriorityValues()
    }
}
