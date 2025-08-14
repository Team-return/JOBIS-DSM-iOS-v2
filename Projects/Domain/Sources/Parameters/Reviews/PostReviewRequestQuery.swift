import Foundation

public struct PostReviewRequestQuery: Encodable {
    public let interviewType: InterviewFormat
    public let location: LocationType
    public let companyID: Int
    public let jobCode: Int
    public let interviewerCount: Int
    public var qnas: [QnaRequestQuery]
    public let question: String
    public let answer: String

    public init(
        interviewType: InterviewFormat,
        location: LocationType,
        companyID: Int,
        jobCode: Int,
        interviewerCount: Int,
        qnas: [QnaRequestQuery],
        question: String,
        answer: String
    ) {
        self.interviewType = interviewType
        self.location = location
        self.companyID = companyID
        self.jobCode = jobCode
        self.interviewerCount = interviewerCount
        self.qnas = qnas
        self.question = question
        self.answer = answer
    }

    enum CodingKeys: String, CodingKey {
        case interviewType = "interview_type"
        case location
        case companyID = "company_id"
        case jobCode = "job_code"
        case interviewerCount = "interviewer_count"
        case qnas
        case question
        case answer
    }
}

public struct QnaRequestQuery: Encodable {
    public let questionID: Int
    public let answer: String

    public init(questionID: Int, answer: String) {
        self.questionID = questionID
        self.answer = answer
    }

    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case answer
    }
}
