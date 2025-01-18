//
//  DateTimePickerViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

final class DateTimePickerViewModel: ObservableObject {

   @Published private(set) var selection: DateTimeSelection
   @Published var isPresented: Bool = false
   @Published var isPressed: Bool = false

   private let initialStartTime: Date
   private let initialEndTime: Date

   init() {
       let now = Date()
       self.initialStartTime = now
       self.initialEndTime = now

       self.selection = DateTimeSelection(
           startsDate: now,
           endsDate: now,
           isAllDay: false,
           selectedStartTime: now,
           selectedEndTime: now
       )
   }

   var startsDate: Date {
       get { selection.startsDate }
       set {
           selection.startsDate = newValue
           validateAndUpdateDates()
       }
   }

   var endsDate: Date {
       get { selection.endsDate }
       set {
           selection.endsDate = newValue
           validateAndUpdateDates()
       }
   }

   var isAllDay: Bool {
       get { selection.isAllDay }
       set {
           selection.isAllDay = newValue
           updateTimesForAllDayStatus(newValue)
       }
   }

   var selectedStartTime: Date {
       get { selection.selectedStartTime }
       set { selection.selectedStartTime = newValue }
   }

   var selectedEndTime: Date {
       get { selection.selectedEndTime }
       set { selection.selectedEndTime = newValue }
   }

   var formattedStartTime: String {
       formatTimeString(selection.selectedStartTime)
   }

   var formattedEndTime: String {
       formatTimeString(selection.selectedEndTime)
   }

   func togglePresentation() {
       guard !selection.isAllDay else { return }
       isPresented.toggle()
       isPressed = true
   }

   func confirmSelection() {
       isPresented = false
       isPressed = false
   }

   func resetToInitialTime() {
       selection.selectedStartTime = initialStartTime
       selection.selectedEndTime = initialEndTime
   }

   func dismiss() {
       isPresented = false
       isPressed = false
   }

   private func formatTimeString(_ date: Date) -> String {
       selection.isAllDay ? "All-day" : date.formattedDate(with: "h:mm a")
   }

   private func validateAndUpdateDates() {
       guard selection.startsDate > selection.endsDate else { return }

       selection.endsDate = selection.startsDate
       if !selection.isAllDay {
           selection.selectedEndTime = selection.selectedStartTime
       }
   }

   private func updateTimesForAllDayStatus(_ isAllDay: Bool) {
       if isAllDay {
           selection.selectedStartTime = Calendar.current.startOfDay(for: selection.startsDate)
           selection.selectedEndTime = Calendar.current.startOfDay(for: selection.endsDate)
       } else {
           resetToInitialTime()
       }
   }
}
