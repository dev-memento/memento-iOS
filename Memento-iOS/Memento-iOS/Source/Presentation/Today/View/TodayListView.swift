//
//  TodayListView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

struct TodayListView: View {
    @StateObject private var viewModel = TodayListViewModel()

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
    }
}

private extension TodayListView {
    func renderItem(at index: Int) -> some View {
        let item = viewModel.items[index]
        let isDragging = item.id == viewModel.dragItem?.id

        return TodayListItemView(item: $viewModel.items[index])
            // 드래그 시작
            .onDrag {
                viewModel.dragItem = item
                return NSItemProvider()
            }
            // 드롭 시작
            .onDrop(
                of: [.text],
                delegate: DropViewDelegate(
                    item: $viewModel.items[index],
                    items: $viewModel.items,
                    draggedItem: $viewModel.dragItem,
                    dropIndex: $viewModel.dropIndex,
                    onDrop: viewModel.dropAction
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

// MARK: - DropViewDelegate

struct DropViewDelegate: DropDelegate {
    
    @Binding var item: TodayItemDataModel
    @Binding var items: [TodayItemDataModel]
    @Binding var draggedItem: TodayItemDataModel?
    @Binding var dropIndex: Int?
    
    let onDrop: (TodayItemDataModel?, TodayItemDataModel) -> Void

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    // 드롭 완료
    func performDrop(info: DropInfo) -> Bool {
        withAnimation {
            draggedItem = nil
            dropIndex = nil
        }
        return true
    }

    // 드롭 대상에 진입
    func dropEntered(info: DropInfo) {
        guard let draggedItem else { return }
        onDrop(draggedItem, item)
        dropIndex = items.firstIndex { $0.id == item.id }
    }

    // 드롭 대상에서 벗어났을 때
    func dropExited(info: DropInfo) {
        withAnimation {
            dropIndex = nil
        }
    }
}
