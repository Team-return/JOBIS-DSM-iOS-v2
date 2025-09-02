import Foundation
import Domain

public struct ReviewDetailResponseDTO: Decodable {
    public let reviewID: Int
    public let companyName: String
    public let writer: String
    public let year: Int
    public let major: String
    public let type: InterviewFormat
    public let location: LocationType
    public let interviewerCount: Int
    public let qnAs: [QnAResponseDTO]
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
        qnAs: [QnAResponseDTO],
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

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case companyName = "company_name"
        case writer
        case year
        case major
        case type
        case location
        case interviewerCount = "interviewer_count"
        case qnAs = "qn_as"
        case question
        case answer
    }
}

public struct QnAResponseDTO: Decodable {
    public let id: Int
    public let question: String
    public let answer: String

    public init(id: Int, question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

public extension ReviewDetailResponseDTO {
    func toDomain() -> ReviewDetailEntity {
        ReviewDetailEntity(
            reviewID: reviewID,
            companyName: companyName,
            writer: writer,
            year: year,
            major: major,
            type: InterviewFormat(rawValue: type.rawValue)!,
            location: LocationType(rawValue: location.rawValue)!,
            interviewerCount: interviewerCount,
            qnAs: qnAs.map { $0.toDomain() },
            question: question,
            answer: answer
        )
    }
}

public extension QnAResponseDTO {
    func toDomain() -> QnAEntity {
        QnAEntity(
            id: id,
            question: question,
            answer: answer
        )
    }
}
