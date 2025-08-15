import Foundation

public struct ReviewListPageCountRequestQuery: Encodable {
    public let location: LocationType?
    public let interviewType: InterviewFormat?
    public let companyID: Int?
    public let year: Int?
    public let jobCode: Int?

    public init(
        location: LocationType? = nil,
        interviewType: InterviewFormat? = nil,
        companyID: Int? = nil,
        year: Int? = nil,
        jobCode: Int? = nil
    ) {
        self.location = location
        self.interviewType = interviewType
        self.companyID = companyID
        self.year = year
        self.jobCode = jobCode
    }

    enum CodingKeys: String, CodingKey {
        case location
        case interviewType = "interview_type"
        case companyID = "company_id"
        case year
        case jobCode = "job_code"
    }
}
