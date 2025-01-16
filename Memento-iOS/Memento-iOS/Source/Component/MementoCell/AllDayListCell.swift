//
//  AllDayListCell.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/17/25.
//

import SwiftUI

struct AllDayListCell: View {
    var colorType: String
    var allDayTitle: String
    
    var body: some View {
        HStack(spacing: 21) {
            ColorTagView(colorType: colorType)
            
            AllDayTitleView(title: allDayTitle)
            
            Spacer()
        }
        .frame(height: 32)
        .background(Color.mainNavy)
    }
}

struct AllDayTitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .applyFont(.body_r_14)
            .foregroundColor(.gray05)
            .frame(width: 300, alignment: .leading)
    }
}
