//
//  MCalendarEventList.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//
//
import Foundation

import MCalendar

struct MCalendarEventList: Hashable {
    let dateModel: MCalendarDataModel
    let eventList: [MCalendarEventDataModel]
}

struct MCalendarEventDataModel: Hashable, Identifiable {
    let id: UUID = .init()
    let eventTitle: String
    let eventType: MCalendarEventType
    let eventStart: Date
    let envetFinish: Date
    let externalEventType: MCalendarExternalEventType
    let priority: MCalendarPirotity
    let isCompleted: Bool?
}

enum MCalendarEventType {
    case schedule
    case todo
}

enum MCalendarExternalEventType {
    case notion
    case google
    case slack
    case apple
    case none
}

enum MCalendarPirotity {
    case immediate
    case high
    case medium
    case low
    case none
}
