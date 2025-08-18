//
//  ScheduleListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

import MDSKit

struct ScheduleListCell: View {
    
    var tagColorCode: String
    var title: String
    var scheduleType: String
    var endDate: String
    var timeDuration: String
    
    var body: some View {
        HStack(spacing: 10) {
            ColorTagView(colorType: tagColorCode, width: 3)
            
            IconView()
            
            VStack(alignment: .leading, spacing: 8) {
                ScheduleTitleView(title: title)
                
                TimeInfoView(scheduleType: scheduleType, timeDuration: timeDuration)
            }
            
            Spacer()
        }
        .frame(height: 68)
        .background(Color.mainNavy)
        .opacity(Date.hasScheduleEnded(endDate: endDate) ? 0.5 : 1.0)
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
    
    var scheduleType: String
    var timeDuration: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(.img_notion)
            
            Text(timeDuration)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
        }
    }
}
