import Foundation

public struct QuestionEntity: Equatable, Hashable {
    public let id: Int
    public let question: String

    public init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
}
