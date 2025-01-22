//
//  SleepCycleRequestModel.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/21/25.
//

import Foundation

struct SleepCycleRequestModel: Encodable {
    let wakeUpTime: String?
    let windDownTime: String?
    let job: String?
    let jobOtherDetail: String?
    let isStressedUnorganizedSchedule: Bool
    let isForgetImportantThings: Bool
    let isPreferReminder: Bool
    let isImportantBreaks: Bool
}

extension SleepCycleRequestModel {
    init(sleepCycleData: SleepCycleData,
         workSelectionData: WorkSelectionData,
         workPreferenceData: WorkPreferenceData) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        self.wakeUpTime = sleepCycleData.wakeUpTime != nil ? dateFormatter.string(from: sleepCycleData.wakeUpTime!) : nil
        self.windDownTime = sleepCycleData.sleepTime != nil ? dateFormatter.string(from: sleepCycleData.sleepTime!) : nil
        self.job = workSelectionData.selectedCategory
        self.jobOtherDetail = workSelectionData.customCategory
        self.isStressedUnorganizedSchedule = workPreferenceData.selectedAnswers.values.contains(true)
        self.isForgetImportantThings = workPreferenceData.selectedAnswers.values.contains(true)
        self.isPreferReminder = workPreferenceData.selectedAnswers.values.contains(true)
        self.isImportantBreaks = workPreferenceData.selectedAnswers.values.contains(true)
    }
}
