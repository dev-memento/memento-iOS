//
//  ScheduleAlertView.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/16/25.
//

import SwiftUI

struct ScheduleAlertView: View {
    let scheduleTitle: String
    let startDate: String
    let endDate: String
    let tag: String
    let source: String

    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Image(.ic_event)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(scheduleTitle)
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.leading, 16)

            HStack {
                Text(StringLiteral.Alert.start)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 42)

                Text(startDate)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.grayWhite)

                Spacer()
            }
            .padding(.top, 18)
            .padding(.leading, 46)

            HStack {
                Text(StringLiteral.Alert.end)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 48)

                Text(endDate)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.grayWhite)

                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)

            HStack {
                Text(StringLiteral.Alert.tag)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 54)

                HStack(spacing: 3) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    Text(tag)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.grayWhite)
                }

                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)

            HStack {
                Text(StringLiteral.Alert.from)
                    .applyFont(.detail_r_12)
                    .foregroundColor(.gray05)
                    .padding(.trailing, 47)

                HStack(spacing: 3) {
                    Image(.img_notion)
                        .resizable()
                        .frame(width: 17, height: 17)
                    Text(source)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.grayWhite)
                }

                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)

            Spacer()

            HStack {
                Button(action: {
                    onDelete()
                }) {
                    VStack {
                        Image(.ic_delete)
                            .foregroundColor(.mementoRed)
                        Text(StringLiteral.Alert.delete)
                    }
                    .applyFont(.body_b_16)
                    .foregroundColor(.mementoRed)
                    .padding()
                    .frame(width: 140, height: 74)
                    .background(Color.labelImmediate15)
                    .cornerRadius(2)
                }

                Button(action: {
                    onEdit()
                }) {
                    VStack {
                        Image(.ic_edit)
                        Text(StringLiteral.Alert.edit)
                    }
                    .applyFont(.body_b_16)
                    .foregroundColor(.grayWhite)
                    .padding()
                    .frame(width: 140, height: 74)
                    .background(Color.gray09)
                    .cornerRadius(2)
                }
            }
//            .padding(.bottom, 26)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 332)
        .padding()
        .background(Color.gray10)
        .cornerRadius(2)
    }
}

#Preview {
    ScheduleAlertView(
        scheduleTitle: "UXUI 과제",
        startDate: "Jan 31, 2025 8PM",
        endDate: "Jan 31, 2025 11PM",
        tag: "SOPT",
        source: "Notion",
        onDelete: {
            print("Delete button tapped")
        },
        onEdit: {
            print("Edit button tapped")
        }
    )
}
