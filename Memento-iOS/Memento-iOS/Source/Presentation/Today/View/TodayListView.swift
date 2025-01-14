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
        .schedule(ScheduleDataModel(title: "지금은새벽5시다", time: "12 PM - 4 PM", tagColor: "green", isCompleted: true)),
        .todo(TodoDataModel(title: "독감조심하세요다들", dueDate: "Today", priority: .medium, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "회의어쩌고저쩌고메멘토회의", time: "2 PM - 3 PM", tagColor: "orange", isCompleted: false)),
        .schedule(ScheduleDataModel(title: "나는지금배고프다", time: "2 PM - 3 PM", tagColor: "yellow", isCompleted: false)),
        .todo(TodoDataModel(title: "공차가너무먹고싶어요", dueDate: "Today", priority: .none, isChecked: false, tagColor: "blue")),
        .schedule(ScheduleDataModel(title: "하다보니깐6시다", time: "12 PM - 4 PM", tagColor: "red", isCompleted: false)),
        .todo(TodoDataModel(title: "이것만하고자야징", dueDate: "Today", priority: .high, isChecked: false, tagColor: "green")),
        .todo(TodoDataModel(title: "맥너겟어쩌고저쩌고", dueDate: "Today", priority: .low, isChecked: false, tagColor: "orange"))
    ]
    
    @State var draggedItem: TodayItem?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(items.indices, id: \.self) { index in
                    renderItem(at: index)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.black)
    }
    
    private func renderItem(at index: Int) -> some View {
        TodayListItemView(item: $items[index])
        // 드래그 시작 시 draggedItem 업데이트
            .onDrag {
                self.draggedItem = items[index]
                return NSItemProvider()
            }
        // 드롭 액션 처리 (text type)
            .onDrop(
                of: [.text],
                delegate: DropViewDelegate(
                    item: $items[index],
                    items: $items,
                    draggedItem: $draggedItem
                )
            )
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
                time: schedule.time,
                isCompleted: schedule.isCompleted
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
    var isCompleted: Bool
}

struct DropViewDelegate: DropDelegate {
    @Binding var item: TodayItem
    @Binding var items: [TodayItem]
    @Binding var draggedItem: TodayItem?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              draggedItem.id != item.id,
              let toIndex = items.firstIndex(where: { $0.id == item.id }),
              let fromIndex = items.firstIndex(where: { $0.id == draggedItem.id }) else { return }
        
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }
}
