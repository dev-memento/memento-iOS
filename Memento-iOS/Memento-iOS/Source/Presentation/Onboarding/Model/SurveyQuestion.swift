//
//  SurveyQuestion.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/10/25.
//

import Foundation

struct SurveyQuestion: Identifiable {
    let id = UUID() // 고유 ID
    let question: String // 설문 문항
    
    // 전역 목업 데이터
    static let mockData: [SurveyQuestion] = [
        SurveyQuestion(question: "하루를 시작할 때 중요한 일을 먼저 처리하는 것을 선호하시나요?"),
        SurveyQuestion(question: "마감 기한이 여유 있을 때도, 마감일에 가까워지기 전에 일을 시작하시나요?"),
        SurveyQuestion(question: "한 번에 여러 가지 일을 동시에 처리하는 것이 더 효율적이라고 느끼시나요?"),
        SurveyQuestion(question: "업무/학업 관련 일정을 개인 일정보다 더 중요하게 생각하시나요?"),
    ]
}
