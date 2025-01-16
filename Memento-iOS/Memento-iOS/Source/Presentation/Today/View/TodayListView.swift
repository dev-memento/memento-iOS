//
//  TodayListView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

struct TodayListView: View {
    
    @ObservedObject var viewModel: WeeklyCalendarViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(viewModel.items.indices, id: \.self) { index in
                    renderItem(at: index)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.black)
    }

    private func renderItem(at index: Int) -> some View {
        let currentItem = viewModel.items[index]
        let isHighlighted: Bool = {
            if case .todo(let todo) = currentItem, !todo.isChecked {
                return viewModel.items.prefix(index + 1)
                    .filter {
                        if case .todo(let t) = $0, !t.isChecked { return true }
                        return false
                    }
                    .count == 1
            }
            return false
        }()

        return TodayListItemView(item: $viewModel.items[index], isHighlighted: isHighlighted)
            .onDrag {
                viewModel.dragItem = currentItem
                return NSItemProvider()
            }
            .onDrop(
                of: [.text],
                delegate: DropViewDelegate(
                    item: $viewModel.items[index],
                    items: $viewModel.items,
                    draggedItem: $viewModel.dragItem,
                    onDrop: viewModel.dropAction
                )
            )
    }
}

struct TodayListItemView: View {
    @Binding var item: TodayItemDataModel
    var isHighlighted: Bool

    var body: some View {
        switch item {
        case .todo(let todo):
            ToDoListCell(
                isChecked: $item.todoBinding.isChecked,
                colorType: todo.tagColor,
                toDoTitle: todo.title,
                dueDate: todo.dueDate,
                priorityType: todo.priority,
                isHighlighted: isHighlighted
            )
        case .schedule(let schedule):
            ScheduleListCell(
                colorType: schedule.tagColor,
                scheduleTitle: schedule.title,
                time: schedule.time,
                isCompleted: schedule.isCompleted
            )
        }
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var item: TodayItemDataModel
    @Binding var items: [TodayItemDataModel]
    @Binding var draggedItem: TodayItemDataModel?

    let onDrop: (TodayItemDataModel?, TodayItemDataModel) -> Void

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            draggedItem = nil
        }
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem else { return }
        onDrop(draggedItem, item)
    }
}
