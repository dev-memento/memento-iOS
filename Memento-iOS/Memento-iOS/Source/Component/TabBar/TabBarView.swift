import SwiftUI

import MCalendar

struct TabBarView: View {
    
    @State private var selectedTab: TabBarItem = .today
    @State private var previousTab: TabBarItem = .today
    @State private var segmentedViewHeight: CGFloat = .zero
    @GestureState private var translation: CGFloat = .zero
    @State private var isEditSheetPresented: Bool = false
    @State private var editItem: ToDoItem? = nil
    
    @StateObject var segmentedViewModel = SegmentedMenuViewModel()
    @StateObject var calendarViewModel = WeeklyCalendarViewModel(
        scheduleService: ScheduleAPIService(),
        toDoService: ToDoListAPIService(),
        userUptimeService: UserUptimeAPIService(),
        mCalendarDataSource: MCalendarDataSource(),
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
                
                // Add 탭
                Color.clear
                    .tabItem {
                        selectedTab == .addition
                        ? TabBarItem.addition.selectedItem
                        : TabBarItem.addition.normalItem
                    }
                    .tag(TabBarItem.addition)
                    .onChange(of: selectedTab) { oldValue, newValue in
                        guard newValue == .addition else {
                            previousTab = newValue
                            return
                        }
                        
                        withAnimation {
                            segmentedViewModel.isPresented = true
                        }
                        selectedTab = previousTab
                    }
                
                // ToDoList 탭
                ToDoListWeeklyCalendarView(
                    viewModel: calendarViewModel,
                    editAction: { item in
                        editItem = item
                        isEditSheetPresented = true
                    }
                )
                .tabItem {
                    selectedTab == .todo
                    ? TabBarItem.todo.selectedItem
                    : TabBarItem.todo.normalItem
                }
                .tag(TabBarItem.todo)
            }
            
            if segmentedViewModel.isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        dismissKeyboard()
                        segmentedViewModel.isPresented = false
                        segmentedViewModel.selectedMenu = .checkbox
                    }
                    .zIndex(1)
                
                SegmentedMenuView(viewModel: segmentedViewModel, sheetHeight: $segmentedViewHeight)
                    .zIndex(2)
                    .offset(y: translation)
                    .gesture(
                        DragGesture()
                            .updating($translation) { value, state, _ in
                                if value.translation.height > 0 {
                                    state = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > segmentedViewHeight / 3 {
                                    dismissKeyboard()
                                    segmentedViewModel.isPresented = false
                                    segmentedViewModel.selectedMenu = .checkbox
                                }
                            }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.spring, value: segmentedViewModel.isPresented)
            }
            
            if isEditSheetPresented, let item = editItem {
                EditToDoView(isPresented: $isEditSheetPresented, toDoItem: item)
            }
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
