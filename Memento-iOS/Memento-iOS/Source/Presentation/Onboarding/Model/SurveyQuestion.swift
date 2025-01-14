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
        SurveyQuestion(question: "Do you feel stressed when you have an unorganized schedule?"),
        SurveyQuestion(question: "Do you often forget important tasks or appointments?"),
        SurveyQuestion(question: "Do you prefer reminders to help you stay on track with your tasks?"),
        SurveyQuestion(question: "Do you enjoy working with a structured schedule?"),
    ]
}
