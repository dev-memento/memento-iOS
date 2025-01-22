//
//  SurveyQuestion.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/10/25.
//

import Foundation

struct SurveyQuestion: Identifiable {
    let id = UUID()
    let question: String 
 
    static let mockData: [SurveyQuestion] = [
        SurveyQuestion(question: OnboardingWorkPreferenceText.surveyQuestion1),
        SurveyQuestion(question: OnboardingWorkPreferenceText.surveyQuestion2),
        SurveyQuestion(question: OnboardingWorkPreferenceText.surveyQuestion3),
        SurveyQuestion(question: OnboardingWorkPreferenceText.surveyQuestion4),
    ]
}
