import Foundation

public struct PostReviewRequestQuery: Encodable {
    public let companyID: Int
    public var qnaElements: [QnaElementRequestQuery]

    public init(
        companyID: Int,
        qnaElements: [QnaElementRequestQuery]
    ) {
        self.companyID = companyID
        self.qnaElements = qnaElements
    }

    enum CodingKeys: String, CodingKey {
        case companyID = "company_id"
        case qnaElements = "qna_elements"
    }
}

public struct QnaElementRequestQuery: Encodable {
    public var question, answer: String
    public var codeID: Int

    public init(question: String, answer: String, codeID: Int) {
        self.question = question
        self.answer = answer
        self.codeID = codeID
    }

    enum CodingKeys: String, CodingKey {
        case question, answer
        case codeID = "code_id"
    }
}
