import Foundation
import Domain

struct ReviewDetailResponseDTO: Decodable {
    let qnaResponses: [QnaResponseDTO]

    enum CodingKeys: String, CodingKey {
        case qnaResponses = "qna_responses"
    }
}

struct QnaResponseDTO: Decodable {
    let question, answer, area: String
}

extension ReviewDetailResponseDTO {
    func toDomain() -> [QnaEntity] {
        qnaResponses.map {
            QnaEntity(question: $0.question, answer: $0.answer, area: $0.area)
        }
    }
}
