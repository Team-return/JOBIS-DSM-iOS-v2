import Foundation
import Domain

struct WritableReviewListResponseDTO: Decodable {
    let companies: [WritableReviewCompanyResponseDTO]
}

struct WritableReviewCompanyResponseDTO: Decodable {
    let id: Int
    let name: String
}

extension WritableReviewListResponseDTO {
    func toDomain() -> [WritableReviewCompanyEntity] {
        companies.map {
            WritableReviewCompanyEntity(id: $0.id, name: $0.name)
        }
    }
}
