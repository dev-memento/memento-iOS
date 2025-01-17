//
//  TodayView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/9/25.
//

import SwiftUI

import MDSKit
import MCalendar

struct TodayView: View {
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(viewModel.todayItems.indices, id: \.self) { index in
                    TodayListItemView(
                        item: $viewModel.todayItems[index],
                        isHighlighted: isTopPriorityItem(at: index)
                    )
                    .padding(.horizontal)
                    .onDrag {
                        viewModel.dragItem = viewModel.todayItems[index]
                        return NSItemProvider()
                    }
                    .onDrop(
                        of: [.text],
                        delegate: DropViewDelegate(
                            item: $viewModel.todayItems[index],
                            items: $viewModel.todayItems,
                            draggedItem: $viewModel.dragItem,
                            onDrop: viewModel.dropAction
                        )
                    )
                }
            }
            .padding(.vertical)
        }
        .background(Color.grayBlack)
    }
    
    private func isTopPriorityItem(at index: Int) -> Bool {
        guard case .todo(let todo) = viewModel.todayItems[index], !todo.isChecked else { return false }
        return viewModel.todayItems.prefix(index + 1).filter {
            if case .todo(let t) = $0, !t.isChecked { return true }
            return false
        }.count == 1
    }
}

struct TodayListItemView: View {
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
