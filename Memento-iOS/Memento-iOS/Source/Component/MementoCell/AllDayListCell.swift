//
//  AllDayListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import SwiftUI

struct AllDayListCell: View {
    
    var allday: ScheduleAllDayResponseDataTest
    
    var body: some View {
        HStack(spacing: 21) {
            ColorTagView(colorType: allday.tagColorCode)
            
            AllDayTitleView(title: allday.description)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 32)
        .background(Color.mainNavy)
    }
}

struct AllDayTitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .applyFont(.body_r_14)
            .foregroundColor(.gray05)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
