//
//  AllDayListView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/15/25.
//

import SwiftUI

import MDSKit

struct AllDayListView: View {
    let items: [AllDaySchedulesList]
    
    var body: some View {
        let isScroll = items.count >= 5
        
        ScrollView(isScroll ? .vertical : .init(), showsIndicators: isScroll) {
            VStack(spacing: 3) {
                ForEach(items, id: \..id) { item in
                    AllDayListCell(
                        tagColorCode: item.tagColorCode,
                        title: item.description
                    )
                }
            }
            .frame(maxHeight: isScroll ? .infinity : CGFloat(items.count) * 35)
        }
        .frame(height: isScroll ? 156 : CGFloat(items.count) * 35)
    }
}
