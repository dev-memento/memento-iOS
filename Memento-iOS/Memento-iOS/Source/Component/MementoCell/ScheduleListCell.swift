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
    var scheduleTitle: String
    var startTime: String
    var endTime: String
    
    var isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: colorType)
            
            IconView()
            
            VStack(alignment: .leading, spacing: 8) {
                ScheduleTitleView(title: scheduleTitle)
                TimeInfoView(startTime: startTime, endTime: endTime)
            }
            
            Spacer()
        }
        .frame(height: 68)
        .background(Color.mainNavy)
        .opacity(isCompleted ? 0.5 : 1.0)
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

struct ScheduleTitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .applyFont(.body_b_16)
            .foregroundColor(Color.grayWhite)
        
    }
}

struct TimeInfoView: View {
    var startTime: String
    var endTime: String
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.img_notion)
            Text(startTime)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
                .padding(.leading, 12)
            Text(endTime)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
        }
    }
}
