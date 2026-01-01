import Foundation
import Domain

public struct ReviewQuestionResponseDTO: Codable {
    public let questions: [QuestionDTO]

    public init(questions: [QuestionDTO]) {
        self.questions = questions
    }
}

public struct QuestionDTO: Codable {
    public let id: Int
    public let question: String

    public init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}

extension ReviewQuestionResponseDTO {
    func toDomain() -> [QuestionEntity] {
        return questions.map { $0.toDomain() }
    }
}

extension QuestionDTO {
    func toDomain() -> QuestionEntity {
        return QuestionEntity(
            id: id,
            question: question
        )
    }
}
