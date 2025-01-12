//
//  TodayListView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

struct TodayListView: View {
    @State private var items: [TodayItemDataModel] = [
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
    
    @State private var draggedItem: TodayItemDataModel?
    @State private var dropIndex: Int?

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
    }
    
    private func renderItem(at index: Int) -> some View {
        let isDragging = items[index].id == draggedItem?.id
        
        return TodayListItemView(item: $items[index])
            .onDrag {
                self.draggedItem = items[index]
                return NSItemProvider()
            }
            .onDrop(
                of: [.text],
                delegate: DropViewDelegate(
                    item: $items[index],
                    items: $items,
                    draggedItem: $draggedItem,
                    dropIndex: $dropIndex
                )
            )
    }
}

struct TodayListItemView: View {
    
    @Binding var item: TodayItemDataModel
    
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

struct DropViewDelegate: DropDelegate {
    @Binding var item: TodayItemDataModel
    @Binding var items: [TodayItemDataModel]
    @Binding var draggedItem: TodayItemDataModel?
    @Binding var dropIndex: Int?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            draggedItem = nil
            dropIndex = nil
        }
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
        dropIndex = toIndex
    }

    func dropExited(info: DropInfo) {
        withAnimation {
            dropIndex = nil
        }
    }
}
