//
//  ScheduleDataModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

struct ScheduleListDataModel: Identifiable {
    var id = UUID()
    var colorType: String
    var scheduleTitle: String
    var time: String
    var isCompleted: Bool
}
