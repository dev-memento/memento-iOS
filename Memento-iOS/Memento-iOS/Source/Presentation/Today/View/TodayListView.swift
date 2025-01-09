//
//  TodayListView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

struct TodayListView: View {
    @State private var items: [TodayItem] = [
        .todo(TodoDataModel(title: "UXUI 과제", dueDate: "Today", priority: .immediate, isChecked: false, tagColor: "red")),
        .schedule(ScheduleDataModel(title: "지금은새벽5시다", time: "12 PM - 4 PM", tagColor: "green")),
        .todo(TodoDataModel(title: "독감조심하세요다들", dueDate: "Today", priority: .medium, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", tagColor: "orange")),
        .schedule(ScheduleDataModel(title: "나는지금배고프다", time: "2 PM - 3 PM", tagColor: "yellow")),
        .todo(TodoDataModel(title: "공차가너무먹고싶어요", dueDate: "Today", priority: .none, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "하다보니깐6시다", time: "12 PM - 4 PM", tagColor: "red")),
        .todo(TodoDataModel(title: "이것만하고자야징", dueDate: "Today", priority: .high, isChecked: false, tagColor: "green")),
        .todo(TodoDataModel(title: "맥너겟어쩌고저쩌고", dueDate: "Today", priority: .low, isChecked: false, tagColor: "orange"))
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    TodayListItemView(item: $items[index])
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

struct TodayListItemView: View {
    
    @Binding var item: TodayItem
    
    var body: some View {
        switch item {
        case .todo(let todo):
            TodoListCell(
                isChecked: $item.todoBinding.isChecked,
                todoTitle: todo.title,
                colorType: todo.tagColor,
                dueDate: todo.dueDate,
                priorityType: todo.priority
            )
        case .schedule(let schedule):
            ScheduleListCell(
                colorType: schedule.tagColor,
                title: schedule.title,
                time: schedule.time
            )
        }
    }
}

enum TodayItem: Identifiable {
    
    case todo(TodoDataModel)
    case schedule(ScheduleDataModel)
    
    var id: UUID {
        switch self {
        case .todo(let todo):
            return todo.id
        case .schedule(let schedule):
            return schedule.id
        }
    }
}

extension TodayItem {
    var todoBinding: TodoDataModel {
        get {
            if case .todo(let todo) = self {
                return todo
            } else {
                fatalError("Todo 케이스가 아닙니다")
            }
        }
        set {
            if case .todo = self {
                self = .todo(newValue)
            }
        }
    }
}

struct TodoDataModel: Identifiable {
    var id = UUID()
    var title: String
    var dueDate: String
    var priority: Priority
    var isChecked: Bool
    var tagColor: String
}

struct ScheduleDataModel: Identifiable {
    var id = UUID()
    var title: String
    var time: String
    var tagColor: String
}
