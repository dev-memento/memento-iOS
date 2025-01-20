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
                
                ForEach($viewModel.todayItems, id: \.wrappedValue.id) { item in
                    let isArrow = item.wrappedValue == viewModel.todayItems.first
                    let isHighlighted = isTopPriorityItem(at: item.wrappedValue)
                    
                    TodayListItemView(
                        item: item,
                        isHighlighted: isHighlighted,
                        isArrow: isArrow,
                        backgroundColor: Color.mainNavy
                    )
                    .padding(.horizontal)
                    .onDrag {
                        viewModel.dragTodayItem = item.wrappedValue
                        return NSItemProvider(object: String(item.id.hashValue) as NSString)
                    }
                    .onDrop(of: [.text], delegate: DropViewDelegate(item: item, draggedItem: $viewModel.dragTodayItem, onDrop: viewModel.dropActionForToday))
                }
                
                WindDownFooterView(windDownTime: "11 PM")
            }
            .padding(.vertical)
        }
        .background(Color.grayBlack)
    }
    
    private func isTopPriorityItem(at item: TodayItemDataModel) -> Bool {
        guard case .todo(let todo) = item, !todo.isChecked else { return false }
        let uncheckedItems = viewModel.todayItems.filter {
            if case .todo(let t) = $0, !t.isChecked { return true }
            return false
        }
        return uncheckedItems.first == item
    }
}

struct TodayListItemView: View {
    @Binding var item: TodayItemDataModel
    
    var isHighlighted: Bool
    var isArrow: Bool
    var backgroundColor: Color
    
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
                    isHighlighted: isHighlighted,
                    backgroundColor: backgroundColor
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
