//
//  ScheduleListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI
import MDSKit

struct ScheduleListCell: View {
    
    var colorType: String
    var title: String
    var time: String
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: colorType)
            
            IconView()
            
            VStack(alignment: .leading, spacing: 8) {
                TitleView(title: title)
                TimeInfoView(time: time)
            }
            
            Spacer()
        }
        .frame(height: 68)
        .background(Color.grayBlack)
    }
}

struct IconView: View {
    var body: some View {
        VStack {
            Image(.ic_event)
            Spacer()
        }
        .padding(.top, 11)
    }
}

struct TitleView: View {
    var title: String
    
    var body: some View {
        
        Text(title)
            .applyFont(.body_b_16)
            .foregroundColor(Color.grayWhite)
        
    }
}

struct TimeInfoView: View {
    var time: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.img_notion)
            Text(time)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
                .padding(.leading, 12)
        }
    }
}

#Preview {
    TodayListView()
}
