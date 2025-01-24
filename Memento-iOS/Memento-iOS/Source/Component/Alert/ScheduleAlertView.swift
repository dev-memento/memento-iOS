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
    let tag: String
    let source: String
    
    var onDelete: () -> Void
    var onEdit: () -> Void
    var scheduleAPIService: ScheduleAPIServiceProtocol

    @State private var isLoading: Bool = false

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
                    .foregroundColor(.gray05)
                
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
                    .foregroundColor(.gray05)
                
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
                    Image(.ic_tag)
                        .renderingMode(.template)
                        .foregroundColor(.mementoBlue)
                    Text(tag)
                        .applyFont(.detail_r_12)
                        .foregroundColor(.gray05)
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
                        .foregroundColor(.gray05)
                }
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 46)
            
            Spacer()
            
            HStack(spacing: 15) {
                DeleteButton(onDelete: deleteSchedule)
                EditButton(onEdit: onEdit)
            }
            .padding(.bottom, 26)
            .padding(.horizontal, 24)
        }
        .frame(width: 343, height: 332)
        .background(Color.gray10)
        .cornerRadius(2)
    }

    // MARK: - API

    private func deleteSchedule() {
        isLoading = true
        scheduleAPIService.deleteSchedule(scheduleId: scheduleId) { result in
            print("DEBUG: Requesting DELETE for Todo ID: \(scheduleId)")
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    onDelete()
                    print("DEBUG: Schedule 삭제 성공")
                case .badRequest:
                    onDelete()
                    print("DEBUG: 잘못된 요청입니다. - Schedule 삭제 실패")
                case .notFound:
                    onDelete()
                    print("DEBUG: 잘못된 요청입니다. - Schedule 삭제 실패")
                case .serverError:
                    onDelete()
                    print("DEBUG: 내부 서버 에러 - Schedule 삭제 실패")
                default:
                    onDelete()
                    print("DEBUG: 알 수 없는 에러 - Schedule 삭제 실패")
                }
            }
        }
    }
}

#Preview {
    ScheduleAlertView(
        scheduleId: 1,
        scheduleTitle: "UXUI 과제",
        startDate: "Jan 31, 2025  8PM",
        endDate: "Jan 31, 2025  11PM",
        tag: "SOPT",
        source: "Notion",
        onDelete: {
            print("Delete button tapped")
        },
        onEdit: {
            print("Edit button tapped")
        },
        scheduleAPIService: ScheduleAPIService()
    )
}
