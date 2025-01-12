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
            
            VStack{
                Image(.ic_event)
                
                Spacer()
            }
            .padding(.top, 11)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .applyFont(.body_b_16)
                    .foregroundColor(Color.grayWhite)
                HStack(spacing: 0) {
                    Image(.img_notion)
                    
                    Text(time)
                        .applyFont(.detail_r_12)
                        .foregroundColor(Color.gray05)
                        .padding(.leading, 12)
                    
                }
            }
            
            Spacer()
        }
        .frame(height: 68)
        .background(Color.grayBlack)
    }
}


//struct IconView: View {
//    var systemName: String
//    var size: CGFloat
//
//    var body: some View {
//        Image(systemName: systemName)
//            .resizable()
//            .frame(width: size, height: size)
//            .foregroundColor(.white)
//    }
//}

//struct TitleView: View {
//    var title: String
//
//    var body: some View {
//        Text(title)
//            .applyFont(.body_b_16)
//            .foregroundColor(Color.grayWhite)
//    }
//}

//struct TimeInfoView: View {
//    var systemImageName: String
//    var timeText: String
//
//    var body: some View {
//        HStack(spacing: 12) {
//            IconView(systemName: systemImageName, size: 14)
//            Text(timeText)
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//}
