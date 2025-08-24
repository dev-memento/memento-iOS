//
//  ToDoListView.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/10/25.
//

import SwiftUI

import MDSKit
import MCalendar

struct ToDoListView: View {
    
    @ObservedObject var viewModel: WeeklyCalendarViewModel
    
    var onTap: (ToDoItem) -> Void
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.mCallendarDataSource.wholeMonthDate, id: \.self) { date in
                        
                        ToDoListDateView(date: "\(Date.makeMonthDate(month: date.month)) \(date.day)")
                            .id(date)
                            .padding(.bottom, 8)
                        
                        if let events = viewModel.toDoListDict[date], !events.isEmpty {
                            ForEach(events, id: \.id) { event in
                                
                                ToDoListItemView(
                                    item: event,
                                    isHighlighted: viewModel.isTopPriorityItem(at: event, items: events),
                                    isCompleted: viewModel.bindingForToDoCompletion(event.id)
                                )
                                .onTapGesture {
                                    onTap(event)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.grayBlack)
            .onAppear {
                viewModel.getToDoListTotal()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("postToDo"))) { _ in
                viewModel.getToDoListTotal()
            }
        }
    }
}

struct ToDoListDateView: View {
    
    var date: String
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray07)
                .frame(height: 10)
                .padding(.bottom, 2)
            
            HStack {
                Text(date)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray05)
                    .padding(.leading, 22)
                
                Spacer()
            }
            .frame(height: 20)
            .padding(.bottom, 8)
        }
    }
}

struct ToDoListItemView: View {
    
    var item: ToDoItem
    var isHighlighted: Bool
    
    @Binding var isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ToDoListCell(
                tagColorCode: item.tagColor,
                title: item.description,
                toDoType: item.toDoType,
                endDate: item.endDate,
                priority: item.priorityType,
                isHighlighted: isHighlighted,
                isCompleted: $isCompleted
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
