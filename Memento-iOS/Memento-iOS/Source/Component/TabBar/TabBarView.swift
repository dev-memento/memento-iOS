import SwiftUI

import MCalendar

struct TabBarView: View {

    @State private var selectedTab: TabBarItem = .today
    @State private var previousTab: TabBarItem = .today
    @State private var segmentedViewHeight: CGFloat = .zero
    @GestureState private var translation: CGFloat = .zero

    @StateObject var segmentedViewModel = SegmentedMenuViewModel()
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
                Color.clear
                    .tabItem {
                        selectedTab == .addition
                        ? TabBarItem.addition.selectedItem
                        : TabBarItem.addition.normalItem
                    }
                    .tag(TabBarItem.addition)
                    .onAppear {
                        segmentedViewModel.isPresented = true
                        selectedTab = previousTab
                    }
                    .onChange(of: selectedTab) { _, newValue in
                        if newValue == .addition {
                            withAnimation {
                                segmentedViewModel.isPresented = true
                            }
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
            }

            if segmentedViewModel.isPresented {
                Color.black.opacity(0.5)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        dismissKeyboard()
                        segmentedViewModel.isPresented = false
                        segmentedViewModel.selectedButton = .checkbox
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
                                    segmentedViewModel.selectedButton = .checkbox
                                }
                            }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.spring, value: segmentedViewModel.isPresented)
            }
        }
        .onAppear {
            calendarViewModel.getToDoListTotalAPI()
            calendarViewModel.getSchedulesTotalAPI()
            todolistViewModel.getToDoListTotalAPI()
            
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
