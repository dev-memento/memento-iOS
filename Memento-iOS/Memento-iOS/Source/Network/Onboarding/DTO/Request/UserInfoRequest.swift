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
