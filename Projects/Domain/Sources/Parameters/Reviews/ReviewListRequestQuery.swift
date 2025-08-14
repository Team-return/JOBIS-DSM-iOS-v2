import Foundation

public struct ReviewListRequestQuery: Encodable {
    public let page: Int?
    public let location: LocationType?
    public let interviewType: InterviewFormat?
    public let companyID: Int?
    public let keyword: String?
    public let year: Int?
    public let jobCode: Int?

    public init(
        page: Int? = nil,
        location: LocationType? = nil,
        interviewType: InterviewFormat? = nil,
        companyID: Int? = nil,
        keyword: String? = nil,
        year: Int? = nil,
        jobCode: Int? = nil
    ) {
        self.page = page
        self.location = location
        self.interviewType = interviewType
        self.companyID = companyID
        self.keyword = keyword
        self.year = year
        self.jobCode = jobCode
    }

    enum CodingKeys: String, CodingKey {
        case page
        case location
        case interviewType = "interview_type"
        case companyID = "company_id"
        case keyword
        case year
        case jobCode = "job_code"
    }
}
