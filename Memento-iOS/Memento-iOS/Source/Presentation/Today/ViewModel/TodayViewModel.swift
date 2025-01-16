//
//  TodayViewModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/6/25.
//

import SwiftUI

final class TodayListViewModel: ObservableObject {
    @Published var items: [TodayDataModel] = [
        .todo(ToDoListDataModel(colorType: "red", toDoTitle: "UXUI 과제", dueDate: "Today", priorityType: .immediate, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "green", scheduleTitle: "지금은새벽5시다", time: "12 PM - 4 PM", isCompleted: true)),
        .todo(ToDoListDataModel(colorType: "blue", toDoTitle: "독감조심하세요다들", dueDate: "Today", priorityType: .medium, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "orange", scheduleTitle: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", isCompleted: false)),
        .schedule(ScheduleListDataModel(colorType: "yellow", scheduleTitle: "나는지금배고프다", time: "2 PM - 3 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "blue", toDoTitle: "공차가너무먹고싶어요", dueDate: "Today", priorityType: .none, isChecked: false)),
        .schedule(ScheduleListDataModel(colorType: "red", scheduleTitle: "하다보니깐6시다", time: "12 PM - 4 PM", isCompleted: false)),
        .todo(ToDoListDataModel(colorType: "green", toDoTitle: "이것만하고자야징", dueDate: "Today", priorityType: .high, isChecked: false)),
        .todo(ToDoListDataModel(colorType: "orange", toDoTitle: "맥너겟어쩌고저쩌고", dueDate: "Today", priorityType: .low, isChecked: false))
    ]
    
    @Published var dragItem: TodayDataModel?
    @Published var dropIndex: Int?
    
    func dropAction(dragItem: TodayDataModel?, dropItem: TodayDataModel) {
        guard let dragItem,
              let toIndex = items.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = items.firstIndex(where: { $0.id == dragItem.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
