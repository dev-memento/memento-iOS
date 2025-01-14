//
//  MEventDataSource.swift
//  Memento-iOS
//
//  Created by Kimgahyun on 1/14/25.
//

import Foundation

import MCalendar

final class MEventDatasource: ObservableObject {
    var eventList: [MCalendarEventList] = []
    
    //MARK: - setEvent
    func setCalendarData(_ calendarData: [MCalendarDataModel]) {
        //더미 이벤트 생성 부
        //event fetch 후 바꾸쇼 / 모든 캘린더 데이터에 대한 이벤트가 빈 배열로라도 존재 해야 합니다 . . . . . . . .
        //그럼 서버꺼 다 가져와야 되냐? ㄴㄴ 클라에서 들고있는거랑 서버는 별개니까 알아서 페이징 해서 꽂으쇼
        //지금 내가 어디보는지 알 수 있으니까 (selected Date) 그걸로 불러와서 알아서 페이징 잘 치면 됨.
        calendarData.forEach {
            if let now = $0.date() {
                eventList.append(.init(dateModel: $0,
                                       eventList: [.init(eventTitle: $0.year + "년" + $0.month + "월" + $0.day + "일" + "이벤트",
                                                         eventType: .schedule,
                                                         eventStart: now,
                                                         envetFinish: now.addingTimeInterval(60 * 60),
                                                         externalEventType: .notion,
                                                         priority: .immediate,
                                                         isCompleted: false)]))
            }
        }
    }
    
}
