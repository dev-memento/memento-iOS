import Foundation

struct PostCreateScheduleRequest: Codable  {
    let description, startDate, endDate: String
    let isAllDay: Bool
    let tagID: Int
    
    enum CodingKeys: String, CodingKey {
        case description, startDate, endDate, isAllDay
        case tagID = "tagId"
    }
}
