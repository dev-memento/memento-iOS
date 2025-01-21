//
//  TabBarView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/7/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: TabBarItem = .today
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabBarItem.allCases, id: \.self) { tab in
                tab.targetView
                    .tabItem {
                        (selectedTab == tab ? tab.selectedItem : tab.normalItem)
                    }
            }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.mainNavy)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    TabBarView()
}
