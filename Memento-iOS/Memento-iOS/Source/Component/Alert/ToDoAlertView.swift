//
//  ToDoAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct ToDoAlertView: View {

    let todoId: Int
    let todoTitle: String
    let deadline: String
    let tag: String
    let priority: Priority
    
    @Binding var isChecked: Bool
    
    var onDelete: () -> Void
    var onEdit: () -> Void
    var todoAPIService: TodoAPIServiceProtocol

    @State private var isLoading: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(isChecked ? .btn_check_selected_square : .btn_check_unselected_square)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text(todoTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .strikethrough(isChecked, color: .grayWhite)
                Spacer()
            }
            .padding(.top, 22)
            .padding(.leading, 16)
            
            HStack {
                Text(StringLiteral.Alert.deadline)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 27)
                
                HStack(spacing: 3) {
                    Image(.ic_deadline)
                        .foregroundColor(.gray05)
                    Text(deadline)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)
            
            
            HStack {
                Text(StringLiteral.Common.tag)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 54)
                
                HStack(spacing: 3) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(.mementoBlue)
                    Text(tag)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)
            
            
            HStack {
                Text(StringLiteral.Alert.priority)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 36)
                
                PriorityLabel(priority: priority)
                Spacer()
            }
            .padding(.top, 14)
            .padding(.leading, 46)
            
            Spacer()
            
            HStack(spacing: 15) {
                DeleteButton(onDelete: deleteTodo)
                EditButton(onEdit: onEdit)
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 300)
        .background(Color.gray10)
        .cornerRadius(2)
    }

    // MARK: - API

    private func deleteTodo() {
        isLoading = true
        todoAPIService.deleteTodo(todoId: todoId) { result in
            print("DEBUG: Requesting DELETE for Todo ID: \(todoId)")
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    onDelete()
                    print("DEBUG: Todo 삭제 성공")
                case .badRequest:
                    print("DEBUG: 잘못된 요청입니다. - Todo 삭제 실패")
                case .unAuthorized:
                    print("DEBUG: 유효하지 않은 토큰입니다. - Todo 삭제 실패")
                case .notFound:
                    print("DEBUG: 잘못된 요청입니다. - Todo 삭제 실패")
                case .serverError:
                    print("DEBUG: 내부 서버 에러 - Todo 삭제 실패")
                default:
                    print("DEBUG: 알 수 없는 에러 - Todo 삭제 실패")
                }
            }
        }
    }
}
