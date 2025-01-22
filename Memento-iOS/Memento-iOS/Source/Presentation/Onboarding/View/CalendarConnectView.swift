//
//  CalendarConnectView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/11/25.
//

import SwiftUI
import EventKit

import MDSKit

struct CalendarConnectView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel 

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .center) {
                CustomNavigationBar(
                    showBackButton: true,
                    showSkipButton: false,
                    backButtonAction: {
                        viewModel.navigateBack()
                    }
                )
                .padding([.trailing, .top], 16)

                CalendarConnectHeaderView()
                    .padding(.horizontal)

                CalendarConnectButtons()
                    .padding(.top, 133)

                Spacer()

                AppStartButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Header and Title View

private struct CalendarConnectHeaderView: View {
    var body: some View {
        ZStack {
            Image(.img_calendar)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 80)
                .foregroundColor(Color.gray09)
                .opacity(0.5)
                .offset(x: 110, y: 35)

            VStack(alignment: .center) {
                Text(OnboardingCalendarConnectText.calendarConnectHeaderTitle)
                    .applyFont(.title_b_24)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
        }
        .padding()
    }
}

// MARK: - CalendarConnectButtons

private struct CalendarConnectButtons: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Button {
               
            } label: {
                HStack(spacing: 8) {
                    Image(.img_google)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(OnboardingCalendarConnectText.connectGoogleCalendar)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10)

            Button {
                Task {
                    do {
                        // Fetch events from the calendar
                        let events = try await fetchEventsForTwoYears()
                        // Print the events in a readable format
                        printEvents(events)
                    } catch {
                        print("Failed to fetch events: \(error.localizedDescription)")
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(.img_apple)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(OnboardingCalendarConnectText.connectAppleCalendar)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: 343)
            .frame(height: 46)
            .padding(.horizontal, 16)
            .background(Color.gray10)

        }
    }
}

// MARK: - AppStartButton

private struct AppStartButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel

    var body: some View {
        Button {
            viewModel.navigateToNext(.calendarConnect)
        } label: {
            Text(OnboardingCalendarConnectText.startMementoButton)
                .applyFont(.body_b_16)
                .foregroundColor(Color.black)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(Color.mainGreen)
        .frame(height: 50)
        .cornerRadius(2)
    }
}

func fetchEventsForTwoYears() async throws -> [EKEvent] {
    let store = EKEventStore()
    
    // 권한 요청
    guard try await store.requestFullAccessToEvents() else {
        throw NSError(domain: "CalendarAccessError", code: 1, userInfo: [NSLocalizedDescriptionKey: "캘린더 접근 권한이 없습니다."])
    }
    
    // 현재 날짜 계산
    let currentDate = Date()
    
    // -1년 및 +1년 날짜 계산
    guard let startDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate),
          let endDate = Calendar.current.date(byAdding: .year, value: 1, to: currentDate) else {
        throw NSError(domain: "DateCalculationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "날짜 계산에 실패했습니다."])
    }
    
    // 이벤트 조건 생성
    let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
    
    // 이벤트 가져오기
    let events = store.events(matching: predicate)
    return events.sorted { $0.startDate < $1.startDate }
}

func printEvents(_ events: [EKEvent]) {
    guard !events.isEmpty else {
        print("이번 달에 등록된 일정이 없습니다.")
        return
    }
    
    for event in events {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let startDate = formatter.string(from: event.startDate)
        let endDate = formatter.string(from: event.endDate)
        
        print("""
        제목: \(event.title ?? "제목 없음") (타입: \(type(of: event.title)))
        시작: \(startDate) (타입: \(type(of: startDate)))
        종료: \(endDate) (타입: \(type(of: endDate)))
        위치: \(event.location ?? "위치 정보 없음") (타입: \(type(of: event.location)))
        참석자: \(event.attendees?.map { $0.name ?? "참석자 이름 없음" }.joined(separator: ", ") ?? "참석자 없음") (타입: \(type(of: event.attendees)))
        알림: \(event.alarms?.map { $0.relativeOffset.description }.joined(separator: ", ") ?? "알림 없음") (타입: \(type(of: event.alarms)))
        반복 여부: \(event.recurrenceRules != nil ? "반복 이벤트" : "단일 이벤트") (타입: \(type(of: event.recurrenceRules)))
        올데이 여부: \(event.isAllDay ? "올데이 일정" : "시간 지정 일정") (타입: \(type(of: event.isAllDay)))
        노트: \(event.notes ?? "노트 없음") (타입: \(type(of: event.notes)))
        URL: \(event.url?.absoluteString ?? "URL 없음") (타입: \(type(of: event.url)))
        --------------
        """)
    }
}

#Preview {
    CalendarConnectView().environmentObject(OnboardingViewModel(authViewModel: AuthViewModel()))
}
