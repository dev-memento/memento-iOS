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
    private let tagService: TagAPIServiceProtocol
    
    private let scheduleId: Int
    
    // MARK: - User Input
    
    @Published var description: String
    
    @Published var startDate: String {
        didSet { updateAllDayStatus() }
    }
    
    @Published var endDate: String {
        didSet { updateAllDayStatus() }
    }
    
    @Published var isAllDay: Bool {
        didSet {
            if isAllDay {
                normalizeDatesForAllDay()
            }
        }
    }
    
    @Published var tagName: String
    @Published var tagColorCode: String
    @Published var tagList: [Tag] = []
    
    init(
        scheduleItem: ScheduleItem,
        scheduleService: ScheduleAPIServiceProtocol = ScheduleAPIService(),
        tagService: TagAPIServiceProtocol = TagAPIService()
    ) {
        self.scheduleId = scheduleItem.id
        self.description = scheduleItem.description
        self.startDate = scheduleItem.startDate
        self.endDate = scheduleItem.endDate
        self.tagName = scheduleItem.tagName
        self.tagColorCode = scheduleItem.tagColorCode
        self.isAllDay = scheduleItem.isAllDay
        
        self.scheduleService = scheduleService
        self.tagService = tagService
        
        getTags()
        updateAllDayStatus()
    }
    
    // MARK: - All-Day Handling
    
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
    
    private var dayDifference: Int {
        Calendar.current.dateComponents([.day],
                                        from: Calendar.current.startOfDay(for: startDateTime),
                                        to: Calendar.current.startOfDay(for: endDateTime)
        ).day ?? 0
    }
    
    var isAllDayToggleEnabled: Bool {
        dayDifference < 2
    }
    
    private func updateAllDayStatus() {
        let shouldBeAllDay = isOverOneDay()
        if shouldBeAllDay != isAllDay {
            isAllDay = shouldBeAllDay
        }
    }
    
    private func normalizeDatesForAllDay() {
        startDate = startDateTime.startOfDay.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
        endDate = endDateTime.startOfDay.stringFromDate(with: "yyyy-MM-dd'T'HH:mm:ss")
    }
    
    func toggleAllDay() {
        guard isAllDayToggleEnabled else { return }
        isAllDay.toggle()
    }
    
    func isOverOneDay() -> Bool {
        endDateTime.timeIntervalSince(startDateTime) >= TimeInterval.oneDay
    }
    
    // MARK: - API
    
    func getTags() {
        tagService.getTags { [weak self] result in
            guard let self = self else { return }
            
            guard case let .success(response) = result,
                  let tags = response?.data.map({ Tag(tagId: $0.id, name: $0.name, color: Color(hex: $0.colorCode)) })
            else { return }
            
            self.tagList = tags
            
            if let selected = tags.first(where: { $0.name == self.tagName }) ?? tags.first {
                self.tagName = selected.name
                self.tagColorCode = selected.color.toHex()
            }
        }
    }
    
    func updateSchedule(completion: @escaping () -> Void) {
        let tagId = tagList.first(where: { $0.name == tagName })?.tagId ?? tagList.first?.tagId ?? 1
        
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
