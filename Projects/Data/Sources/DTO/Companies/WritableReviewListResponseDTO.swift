import Foundation
import Domain

struct WritableReviewListResponseDTO: Decodable {
    let companies: [WritableReviewCompanyResponseDTO]
}

struct WritableReviewCompanyResponseDTO: Decodable {
    let reviewID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "id"
        case name
    }
}

extension WritableReviewListResponseDTO {
    func toDomain() -> [WritableReviewCompanyEntity] {
        companies.map {
            WritableReviewCompanyEntity(reviewID: $0.reviewID, name: $0.name)
        }
    }
}
