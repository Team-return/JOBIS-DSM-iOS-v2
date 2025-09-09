import Foundation

struct ReviewQuestionResponseDTO: Codable {
    let questions: [QuestionDTO]
}

struct QuestionDTO: Codable {
    let id: Int64
    let question: String
}
