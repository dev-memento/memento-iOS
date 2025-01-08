//
//  ScheduleListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

struct ScheduleListCell: View {
    
    var colorType: String = "red"
    var title: String = "세미나"
    var time: String = "12PM - 4PM"
    
    var body: some View {
        HStack(spacing: 12) {
            ColorTagView(colorType: colorType)
            
            IconView(systemName: "calendar", size: 20)
            
            VStack(alignment: .leading, spacing: 8) {
                TitleView(title: title)
                TimeInfoView(systemImageName: "shippingbox", timeText: time)
            }
            
            Spacer()
        }
        .frame(height: 70)
        .background(Color.black)
    }
}


struct IconView: View {
    var systemName: String
    var size: CGFloat
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .frame(width: size, height: size)
            .foregroundColor(.white)
    }
}

struct TitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TimeInfoView: View {
    var systemImageName: String
    var timeText: String
    
    var body: some View {
        HStack(spacing: 12) {
            IconView(systemName: systemImageName, size: 14)
            Text(timeText)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}
