//
//  AllDayListView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/15/25.
//

import SwiftUI

struct AllDayListView: View {
    
    let items: [AllDayDataModel]
    
    var body: some View {
        let isScroll = items.count >= 5
        
        ScrollView(isScroll ? .vertical : .init(), showsIndicators: isScroll) {
            VStack(spacing: 3) {
                ForEach(items, id: \.text) { item in
                    AllDayCell(colorType: item.colorType, allDayTitle: item.text)
                }
            }
            .frame(maxHeight: isScroll ? .infinity : CGFloat(items.count) * 35)
        }
        .frame(height: isScroll ? 156 : CGFloat(items.count) * 35)
    }
}
