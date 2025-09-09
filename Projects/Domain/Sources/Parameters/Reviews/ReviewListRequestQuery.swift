import Foundation

public struct ReviewListRequestQuery: Encodable {
    public let page: Int?
    public let location: String?
    public let interviewType: String?
    public let companyID: Int?
    public let keyword: String?
    public let year: String?
    public let jobCode: String?
    public let companyName: String?
    public let writer: String?

    public init(
        page: Int? = nil,
        location: String? = nil,
        interviewType: String? = nil,
        companyID: Int? = nil,
        keyword: String? = nil,
        year: String? = nil,
        jobCode: String? = nil,
        companyName: String? = nil,
        writer: String? = nil
    ) {
        self.page = page
        self.location = location
        self.interviewType = interviewType
        self.companyID = companyID
        self.keyword = keyword
        self.year = year
        self.jobCode = jobCode
        self.companyName = companyName
        self.writer = writer
    }

    enum CodingKeys: String, CodingKey {
        case page
        case location
        case interviewType = "interview_type"
        case companyID = "company_id"
        case keyword
        case year
        case jobCode = "job_code"
        case companyName = "company_name"
        case writer
    }
}
