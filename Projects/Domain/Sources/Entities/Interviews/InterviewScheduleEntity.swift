import Foundation

public struct InterviewScheduleEntity {
    public let id: Int
    public let interviewType: InterviewType
    public let startDate: String
    public let endDate: String
    public let interviewTime: String
    public let companyName: String
    public let location: String
    public let documentNumberID: Int?

    public init(
        id: Int,
        interviewType: InterviewType,
        startDate: String,
        endDate: String,
        interviewTime: String,
        companyName: String,
        location: String,
        documentNumberID: Int?
    ) {
        self.id = id
        self.interviewType = interviewType
        self.startDate = startDate
        self.endDate = endDate
        self.interviewTime = interviewTime
        self.companyName = companyName
        self.location = location
        self.documentNumberID = documentNumberID
    }
}

public struct InterviewScheduleListEntity {
    public let totalCount: Int
    public let interviews: [InterviewScheduleEntity]

    public init(totalCount: Int, interviews: [InterviewScheduleEntity]) {
        self.totalCount = totalCount
        self.interviews = interviews
    }
}
