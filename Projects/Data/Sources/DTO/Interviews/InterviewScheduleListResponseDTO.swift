import Foundation
import Domain

struct InterviewScheduleListResponseDTO: Decodable {
    let totalCount: Int
    let interviews: [InterviewScheduleResponseDTO]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case interviews
    }
}

struct InterviewScheduleResponseDTO: Decodable {
    let id: Int
    let interviewType: InterviewType
    let startDate: String
    let endDate: String
    let interviewTime: String
    let companyName: String
    let location: String
    let documentNumberID: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case interviewType = "interview_type"
        case startDate = "start_date"
        case endDate = "end_date"
        case interviewTime = "interview_time"
        case companyName = "company_name"
        case location
        case documentNumberID = "document_number_id"
    }
}

extension InterviewScheduleListResponseDTO {
    func toDomain() -> InterviewScheduleListEntity {
        InterviewScheduleListEntity(
            totalCount: totalCount,
            interviews: interviews.map {
                InterviewScheduleEntity(
                    id: $0.id,
                    interviewType: $0.interviewType,
                    startDate: $0.startDate,
                    endDate: $0.endDate,
                    interviewTime: $0.interviewTime,
                    companyName: $0.companyName,
                    location: $0.location,
                    documentNumberID: $0.documentNumberID
                )
            }
        )
    }
}
