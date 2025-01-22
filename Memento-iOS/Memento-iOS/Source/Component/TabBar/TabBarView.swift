//
//  TabBarView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/7/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: TabBarItem = .today
    @State private var isAdditionSheetPresented: Bool = false
    @State private var previousTab: TabBarItem = .today
    
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
                ForEach(TabBarItem.allCases, id: \.self) { tab in
                    if tab == .addition {
                        AddView()
                            .tabItem {
                                (selectedTab == tab ? tab.selectedItem : tab.normalItem)
                            }
                            .tag(tab)
                            .onChange(of: selectedTab) { newValue in
                                if newValue == .addition {
                                    isAdditionSheetPresented = true
                                    selectedTab = previousTab
                                }
                            }
                    } else {
                        tab.targetView
                            .tabItem {
                                (selectedTab == tab ? tab.selectedItem : tab.normalItem)
                            }
                            .tag(tab)
                            .onChange(of: selectedTab) { newValue in
                                if newValue != .addition {
                                    previousTab = newValue
                                }
                            }
                    }
                }
            }
            
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
