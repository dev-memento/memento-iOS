//
//  ScheduleAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct ScheduleAlertView: View {

    let scheduleId: Int
    let scheduleTitle: String
    let startDate: String
    let endDate: String
    let tagName: String
    let tagColorCode: String
    let scheduleType: String
    
    var onDelete: () -> Void
    var onEdit: () -> Void

    @State private var isLoading: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image(.ic_event)
                
                Text(scheduleTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 16)
            
            HStack(spacing: 42) {
                Text(StringLiteral.Common.starts)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                Text(Date.displayDate(startDate))
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)
            
            HStack(spacing: 48) {
                Text(StringLiteral.Common.ends)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                Text(Date.displayDate(endDate))
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)
            
            HStack(spacing: 54) {
                Text(StringLiteral.Common.tag)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                
                HStack(spacing: 3) {
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(Color.fromHex(tagColorCode))

                    Text(tagName)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)
            
//            HStack(spacing: 47) {
//                Text(StringLiteral.Alert.from)
//                    .applyFont(.detail_r_12)
//                    .foregroundColor(.gray05)
//                
//                HStack(spacing: 3) {
//                    Image(.img_notion)
//
//                    Text(scheduleType)
//                        .applyFont(.detail_r_12)
//                        .foregroundColor(.gray05)
//                }
//                
//                Spacer()
//            }
//            .padding(.top, 16)
//            .padding(.leading, 46)
            
            Spacer()
            
            HStack(spacing: 15) {
                DeleteButton(onDelete: onDelete)
                EditButton(onEdit: onEdit)
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 300)
        .background(Color.gray10)
        .cornerRadius(2)
    }
}

struct ScheduleAlertView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleAlertView(
            scheduleId: 1,
            scheduleTitle: "회의 일정",
            startDate: "Aug 21, 2025, 10AM",
            endDate: "Aug 21, 2025, 11AM",
            tagName: "Work",
            tagColorCode: "#6CA9E1",
            scheduleType: "Notion",
            onDelete: {},
            onEdit: {}
        )
        .previewLayout(.sizeThatFits)
    }
}
