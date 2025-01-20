//
//  ScheduleDataModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

struct ScheduleListDataModel: Identifiable, Equatable {
    var id = UUID()
    var colorType: String
    var scheduleTitle: String
    var startTime: String
    var endTime: String
    var isCompleted: Bool
}
