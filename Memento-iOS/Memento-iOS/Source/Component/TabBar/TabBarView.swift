import SwiftUI

import MCalendar

struct TabBarView: View {
    @State private var selectedTab: TabBarItem = .today
    @State private var isAdditionSheetPresented: Bool = false
    @State private var previousTab: TabBarItem = .today
    
    @StateObject var calendarViewModel = WeeklyCalendarViewModel(
        mCalendarDataSource: MCalendarDataSource(),
        mEventDataSource: MEventDatasource(),
        scheduleService: ScheduleAPIService(),
        tagService: TagAPIService(),
        toDoListService: ToDoListAPIService(),
        userUptimeService: UserUptimeAPIService()
    )
    
    @StateObject var todolistViewModel = ToDoListViewModel(
        tagService: TagAPIService(),
        toDoListService: ToDoListAPIService(),
        mCallendarDataSource: MCalendarDataSource(),
        mEventDataSource: MEventDatasource()
    )
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.mainNavy)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                // Today 탭
                TodayWeeklyCalendarView(viewModel: calendarViewModel)
                    .tabItem {
                        selectedTab == .today
                        ? TabBarItem.today.selectedItem
                        : TabBarItem.today.normalItem
                    }
                    .tag(TabBarItem.today)
                
                // 가운데 Addition 탭
                AddView()
                    .tabItem {
                        selectedTab == .addition
                        ? TabBarItem.addition.selectedItem
                        : TabBarItem.addition.normalItem
                    }
                    .tag(TabBarItem.addition)
                    .onChange(of: selectedTab) { newValue in
                        if newValue == .addition {
                            isAdditionSheetPresented = true
                            selectedTab = previousTab
                        }
                    }
                
                ToDoListWeeklyCalendarView(viewModel: todolistViewModel)
                    .tabItem {
                        selectedTab == .todo
                        ? TabBarItem.todo.selectedItem
                        : TabBarItem.todo.normalItem
                    }
                    .tag(TabBarItem.todo)
                    .onChange(of: selectedTab) { newValue in
                        if newValue != .addition {
                            previousTab = newValue
                        }
                    }
            }
            
            // 시트 반투명 배경
            if isAdditionSheetPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        isAdditionSheetPresented = false
                    }
            }
        }
        .sheet(isPresented: $isAdditionSheetPresented) {
            SegmentedMenuView()
                .presentationDetents([.fraction(0.8)])
                .presentationDragIndicator(.hidden)
        }
        .onAppear {
            calendarViewModel.getToDoListTotalAPI()
            calendarViewModel.getSchedulesTotalAPI()
            todolistViewModel.getToDoListTotalAPI()
            
        }
    }
}


struct AddView: View {
    var body: some View {
        Color.clear
    }
}

#Preview {
    TabBarView()
}
