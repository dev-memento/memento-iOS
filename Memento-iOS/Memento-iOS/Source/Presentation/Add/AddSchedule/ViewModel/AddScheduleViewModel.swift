import SwiftUI

final class AddScheduleViewModel: ObservableObject {
    private var scheduleApiService: ScheduleAPIService
    
    init(scheduleApiService: ScheduleAPIService) {
        self.scheduleApiService = scheduleApiService
    }
    
    func postAddSchedule(description: String,
                         startDate: String,
                         endDate: String,
                         isAllDay: Bool,
                         tagID: Int,
                        completion: @escaping () -> Void) {
        let body: PostCreateScheduleRequest = .init(description: description,
                                                    startDate: startDate,
                                                    endDate: endDate,
                                                    isAllDay: isAllDay,
                                                    tagID: tagID) //이거 태그 미리 불러서 싱글턴이든 뭐든 좀 들고 있어야 겠구만
        
        print(body)
        scheduleApiService.postCreateSchedule(bodyParam: body,
                                              completion: { [weak self] result in
            guard let self else { return }
            completion()
        })
    }
}
