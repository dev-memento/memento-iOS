//
//  TodayViewModel.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/6/25.
//

import SwiftUI

final class TodayListViewModel: ObservableObject {
    @Published var items: [TodayItemDataModel] = [
        .todo(TodoDataModel(title: "UXUI 과제", dueDate: "Today", priority: .immediate, isChecked: false, tagColor: "red")),
        .schedule(ScheduleDataModel(title: "지금은새벽5시다", time: "12 PM - 4 PM", tagColor: "green", isCompleted: true)),
        .todo(TodoDataModel(title: "독감조심하세요다들", dueDate: "Today", priority: .medium, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", tagColor: "orange", isCompleted: false)),
        .schedule(ScheduleDataModel(title: "나는지금배고프다", time: "2 PM - 3 PM", tagColor: "yellow", isCompleted: false)),
        .todo(TodoDataModel(title: "공차가너무먹고싶어요", dueDate: "Today", priority: .none, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "하다보니깐6시다", time: "12 PM - 4 PM", tagColor: "red", isCompleted: false)),
        .todo(TodoDataModel(title: "이것만하고자야징", dueDate: "Today", priority: .high, isChecked: false, tagColor: "green")),
        .todo(TodoDataModel(title: "맥너겟어쩌고저쩌고", dueDate: "Today", priority: .low, isChecked: false, tagColor: "orange"))
    ]
    
    @Published var dragItem: TodayItemDataModel?
    @Published var dropIndex: Int?
    
    func dropAction(dragItem: TodayItemDataModel?, dropItem: TodayItemDataModel) {
        guard let dragItem,
              let toIndex = items.firstIndex(where: { $0.id == dropItem.id }),
              let fromIndex = items.firstIndex(where: { $0.id == dragItem.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
