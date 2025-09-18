//
//  EditScheduleViewModel.swift
//  Memento-iOS
//
//  Created by 이세민 on 9/8/25.
//

import Foundation
import SwiftUI
import Combine
import MDSKit

final class EditScheduleViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    private let scheduleService: ScheduleAPIServiceProtocol
    
    private let scheduleId: Int
    
    // MARK: - User Input
    
    @Published var description: String
    
    @Published var startDate: String {
        didSet { updateDateTimeAllDayState() }
    }
    
    @Published var endDate: String {
        didSet { updateDateTimeAllDayState() }
    }
    
    @Published var isAllDay: Bool {
        didSet {
            if isUpdatingAllDay { return }
            
            if isAllDay {
                resetDatesToStartOfDay()
            } else {
                isUpdatingAllDay = true
                startDate = originalStartDate
                endDate = originalEndDate
                isUpdatingAllDay = false
            }
        }
    }
    
    @Published var tagName: String
    @Published var tagColorCode: String
    @Published var tagList: [Tag] = []
    
    init(
        scheduleItem: ScheduleItem,
        scheduleService: ScheduleAPIServiceProtocol = ScheduleAPIService()
    ) {
        self.scheduleId = scheduleItem.id
        self.description = scheduleItem.description
        self.startDate = scheduleItem.startDate
        self.endDate = scheduleItem.endDate
        self.tagName = scheduleItem.tagName
        self.tagColorCode = scheduleItem.tagColorCode
        self.isAllDay = scheduleItem.isAllDay
        
        self.scheduleService = scheduleService
        
        self.originalStartDate = scheduleItem.startDate
        self.originalEndDate = scheduleItem.endDate
        
        getTags()
    }
    
    // MARK: - All-Day Handling
    
    private let originalStartDate: String
    private let originalEndDate: String
    
    private var isUpdatingAllDay = false
    
    private var startDateTime: Date {
        Date.dateFromString(startDate, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        ?? Date.dateFromString(startDate, format: "yyyy-MM-dd'T'HH:mm:ss")
        ?? Date()
    }
    
    private var endDateTime: Date {
        Date.dateFromString(endDate, format: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        ?? Date.dateFromString(endDate, format: "yyyy-MM-dd'T'HH:mm:ss")
        ?? Date()
    }
    
    private func resetDatesToStartOfDay() {
        startDate = startDateTime.startOfDay.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
        endDate = endDateTime.startOfDay.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    private func updateDateTimeAllDayState() {
        if isUpdatingAllDay { return }
        
        let interval = endDateTime.timeIntervalSince(startDateTime)
        
        if interval >= .oneDay && !isAllDay {
            isAllDay = true
        }
    }
    
    // MARK: - API
    
    func getTags() {
        guard TagManager.shared.hasLocalTags() else {
            return
        }
        
        let localTags = TagManager.shared.getSavedTags()
        
        let tags = localTags.map { Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) }
        self.tagList = tags
        
        if let selected = tags.first(where: { $0.name == self.tagName }) ?? tags.first {
            self.tagName = selected.name
            self.tagColorCode = selected.color.toHex()
        }
    }
    
    func updateSchedule(completion: @escaping () -> Void) {
        let tagId = tagList.first(where: { $0.name == tagName })?.tagId ?? tagList.first?.tagId ?? 0
        
        let body = SchedulePostRequest(
            description: description,
            startDate: startDate,
            endDate: endDate,
            isAllDay: isAllDay,
            tagId: tagId
        )
        
        scheduleService.updateSchedule(scheduleId: scheduleId, body: body) { _ in
            NotificationCenter.default.post(
                name: Notification.Name("refreshSchedule"),
                object: nil
            )
            
            completion()
        }
    }
}
