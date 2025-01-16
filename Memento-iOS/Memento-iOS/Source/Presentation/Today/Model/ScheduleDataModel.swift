//
//  ScheduleDataModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/13/25.
//

import Foundation

struct ScheduleDataModel: Identifiable {
    var id = UUID()
    var title: String
    var time: String
    var tagColor: String
    var isCompleted: Bool
}
