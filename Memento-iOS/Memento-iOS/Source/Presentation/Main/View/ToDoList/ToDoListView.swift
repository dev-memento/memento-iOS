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
    
    @State private var showTodoAlert = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.mCallendarDataSource.wholeMonthDate, id: \.self) { date in
                        ToDoListDateView(date: "\(makeMonthDate(month: date.month)) \(date.day)")
                            .padding(.bottom, 8)
                            .id(date)
                        let sortedItems = viewModel.toDoListItems
                            .sorted { !$0.isChecked && $1.isChecked }
                        
                        ForEach(viewModel.filteredTargetEvent(date), id: \.self) { item in
                            let originalIndex = viewModel.toDoListItems.firstIndex(where: { $0 == item })!
                            let isHighlighted = isTopPriorityItem(at: item, items: sortedItems)
                            
                            ToDoListItemView(item: item.mapToToDoItem(),
                                             isHighlighted: isHighlighted,
                                             backgroundColor: Color.grayBlack,
                                             onTodoTap: { selectedItem in
                            })
                            .onTapGesture {
                                showTodoAlert = true
                            }
                            
                        }
                    }
                    Spacer()
                }
            }
            .background(Color.grayBlack)
            .onAppear {
                viewModel.getToDoListTotalAPI()
            }
        }
    }
    
    private func isTopPriorityItem(at item: ToDoListDataModel, items: [ToDoListDataModel]) -> Bool {
        guard !item.isChecked else { return false }
        guard let currentIndex = items.firstIndex(where: { $0 == item }) else {
            return false
        }
        let uncheckedCount = items.prefix(upTo: currentIndex).filter { !$0.isChecked }.count
        return uncheckedCount == 0
    }
    
    private func makeMonthDate(month: String) -> String {
        switch month {
        case "1":
            return "Jan"
        case "2":
            return "Feb"
        case "3":
            return "Mar"
        case "4":
            return "Apr"
        case "5":
            return "May"
        case "6":
            return "Jun"
        case "7":
            return "Jul"
        case "8":
            return "Aug"
        case "9":
            return "Sep"
        case "10":
            return "Oct"
        case "11":
            return "Nov"
        case "12":
            return "Dec"
        default:
            return ""
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
        .id(date)
    }
}


#Preview {
    ToDoListView(viewModel: .init(mCalendarDataSource: .init(),
                                  mEventDataSource: .init(),
                                  scheduleService: ScheduleAPIService(),
                                  tagService: TagAPIService(),
                                  toDoListService: ToDoListAPIService()))
}
