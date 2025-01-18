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
                WakeUpHeaderView(wakeUpTime: "8 AM")
                
                ForEach(viewModel.todayItems.indices, id: \.self) { index in
                    let isArrow = index == 0
                    
                    TodayListItemView(
                        item: $viewModel.todayItems[index],
                        isHighlighted: isTopPriorityItem(at: index),
                        isArrow: isArrow
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
                
                WindDownFooterView(windDownTime: "11 PM")
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
    @Binding var item: TodayItemDataModel
    
    var isHighlighted: Bool
    var isArrow: Bool
    
    var body: some View {
        HStack {
            Group {
                if isArrow {
                    Image(systemName: "chevron.down") // TODO: image 변경
                        .foregroundColor(.white)
                        .padding(.trailing, 8)
                } else {
                    Spacer()
                        .frame(width: 20)
                        .padding(.trailing, 8)
                }
            }
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
