import Foundation

public struct ReviewDetailEntity: Equatable, Hashable {
    public let reviewID: Int
    public let companyName: String
    public let writer: String
    public let year: Int
    public let major: String
    public let type: InterviewFormat
    public let location: LocationType
    public let interviewerCount: Int
    public let qnAs: [QnAEntity]
    public let question: String
    public let answer: String

    public init(
        reviewID: Int,
        companyName: String,
        writer: String,
        year: Int,
        major: String,
        type: InterviewFormat,
        location: LocationType,
        interviewerCount: Int,
        qnAs: [QnAEntity],
        question: String,
        answer: String
    ) {
        self.reviewID = reviewID
        self.companyName = companyName
        self.writer = writer
        self.year = year
        self.major = major
        self.type = type
        self.location = location
        self.interviewerCount = interviewerCount
        self.qnAs = qnAs
        self.question = question
        self.answer = answer
    }
}

public struct QnAEntity: Equatable, Hashable {
    public let id: Int
    public let question: String
    public let answer: String

    public init(id: Int, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}
