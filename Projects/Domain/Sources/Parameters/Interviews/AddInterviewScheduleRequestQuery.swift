public struct AddInterviewScheduleRequestQuery: Encodable {
    public let interviewType: String
    public let startDate: String
    public let endDate: String?
    public let interviewTime: String
    public let companyName: String
    public let location: String

    public init(
        interviewType: String,
        startDate: String,
        endDate: String?,
        interviewTime: String,
        companyName: String,
        location: String
    ) {
        self.interviewType = interviewType
        self.startDate = startDate
        self.endDate = endDate
        self.interviewTime = interviewTime
        self.companyName = companyName
        self.location = location
    }

    enum CodingKeys: String, CodingKey {
        case interviewType = "interview_type"
        case startDate = "start_date"
        case endDate = "end_date"
        case interviewTime = "interview_time"
        case companyName = "company_name"
        case location
    }
}
