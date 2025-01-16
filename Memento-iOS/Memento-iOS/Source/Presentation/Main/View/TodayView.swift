//
//  TodayView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import SwiftUI

struct TodayView: View {
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

struct TodayItemView: View {
    @Binding var item: TodayDataModel
    var isHighlighted: Bool

    var body: some View {
        switch item {
        case .todo(let todo):
            ToDoListCell(
                isChecked: $item.toDoBinding.isChecked,
                colorType: todo.colorType,
                toDoTitle: todo.toDoTitle,
                dueDate: todo.dueDate,
                priorityType: todo.priorityType,
                isHighlighted: isHighlighted
            )
        case .schedule(let schedule):
            ScheduleListCell(
                colorType: schedule.colorType,
                scheduleTitle: schedule.scheduleTitle,
                time: schedule.time,
                isCompleted: schedule.isCompleted
            )
        }
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var item: TodayDataModel
    @Binding var items: [TodayDataModel]
    @Binding var draggedItem: TodayDataModel?

    let onDrop: (TodayDataModel?, TodayDataModel) -> Void

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
