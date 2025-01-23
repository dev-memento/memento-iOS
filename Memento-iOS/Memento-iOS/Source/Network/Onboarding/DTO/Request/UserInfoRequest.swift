//
//  SleepCycleRequestModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/21/25.
//

import Foundation

struct UserInfoRequest: Codable {
    let wakeUpTime: String
    let windDownTime: String
    let job: String
    let jobOtherDetail: String?
    let isStressedUnorganizedSchedule: Bool
    let isForgetImportantThings: Bool
    let isPreferReminder: Bool
    let isImportantBreaks: Bool

    init(onboardingData: OnboardingData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"

        self.wakeUpTime = onboardingData.sleepCycle.wakeUpTime.map { dateFormatter.string(from: $0) } ?? "00:00:00"
        self.windDownTime = onboardingData.sleepCycle.sleepTime.map { dateFormatter.string(from: $0) } ?? "00:00:00"
        self.job = onboardingData.workSelection.selectedCategory ?? "TECHNOLOGY"
        self.jobOtherDetail = onboardingData.workSelection.customCategory
        self.isStressedUnorganizedSchedule = onboardingData.workPreference.selectedAnswers.values.contains(true)
        self.isForgetImportantThings = onboardingData.workPreference.selectedAnswers.values.contains(true)
        self.isPreferReminder = onboardingData.workPreference.selectedAnswers.values.contains(true)
        self.isImportantBreaks = onboardingData.workPreference.selectedAnswers.values.contains(true)
    }
}

//struct UserInfoRequest: Codable {
//    let wakeUpTime: String
//    let windDownTime: String
//    let job: String
//    let jobOtherDetail: String
//    let isStressedUnorganizedSchedule: Bool
//    let isForgetImportantThings: Bool
//    let isPreferReminder: Bool
//    let isImportantBreaks: Bool
//
//    // 이 생성자가 있어야만 request를 바로 전달할 수 있습니다.
//    init(_ request: UserInfoRequest) {
//        self.wakeUpTime = request.wakeUpTime
//        self.windDownTime = request.windDownTime
//        self.job = request.job
//        self.jobOtherDetail = request.jobOtherDetail
//        self.isStressedUnorganizedSchedule = request.isStressedUnorganizedSchedule
//        self.isForgetImportantThings = request.isForgetImportantThings
//        self.isPreferReminder = request.isPreferReminder
//        self.isImportantBreaks = request.isImportantBreaks
//    }
//}
