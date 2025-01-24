//
//  ScheduleListCell.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/8/25.
//

import SwiftUI

import MDSKit

struct ScheduleListCell: View {
    var schedule: ScheduleTotalResponseDataTest
    
    // 현재 시간에 맞춰 일정 완료 여부
    private var isCompleted: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone.current

        guard let endDate = formatter.date(from: schedule.endDate) else {
            return false
        }
        return Date() > endDate
    }
    var body: some View {
        HStack(spacing: 10) {
            // Hex 코드가 제대로 넘어오는지 확인
            ColorTagView(colorType: schedule.tagColorCode)
            IconView()

            VStack(alignment: .leading, spacing: 8) {
                ScheduleTitleView(title: schedule.description)
                TimeInfoView(scheduleType: schedule.scheduleType, durationTime: schedule.timeDuration)
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
    var scheduleType: String
    var durationTime: String

    var body: some View {
        HStack(spacing: 0) {
            if let scheduleImage = scheduleIconName(for: scheduleType) {
                scheduleImage
            }
            Text(durationTime)
                .applyFont(.detail_r_12)
                .foregroundColor(Color.gray05)
                .padding(.leading, 12)
        }
    }

    private func formattedTime(startDate: String, endDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone.current

        guard
            let start = formatter.date(from: startDate),
            let end = formatter.date(from: endDate)
        else { return "" }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"

        return "\(outputFormatter.string(from: start)) - \(outputFormatter.string(from: end))"
    }

    private func scheduleIconName(for type: String) -> Image? {
        switch type {
        case "GOOGLE":
            return Image(.img_google)
        case "APPLE":
            return Image(.img_apple)
        default:
            return nil
        }
    }
}

//#Preview {
//    ScheduleListCell(schedule: ScheduleTotalResponseData(id: 0, description: "가ㅏ나다가가라ㅏㅏ마너ㅜ이ㅓㅜ", startDate: "2025-01-15 14:53:00.462351", endDate: "2025-01-23 19:53:00.462351", isAllDay: false, scheduleType: "GOOGLE", order: 1, tagName: "SOPT", tagColorCode: "EE8AAD"))
//}
