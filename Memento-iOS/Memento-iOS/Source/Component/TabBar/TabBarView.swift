//
//  TabBarView.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/7/25.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selectedTab: TabBarItem = .today
    
    init() {
        UITabBar.appearance().backgroundColor = .darkGray
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                ForEach(TabBarItem.allCases, id: \.self) { tabItem in
                    tabItem.targetView
                        .tabItem {
                            VStack {
                                selectedTab == tabItem ? tabItem.selectedItem : tabItem.normalItem
                            }
                        }
                        .tag(tabItem)
                }
            }
            .accentColor(.white)
        }
    }
}
