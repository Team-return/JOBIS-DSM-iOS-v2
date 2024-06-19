import Foundation
import Domain

struct WritableReviewListResponseDTO: Decodable {
    let companies: [WritableReviewCompanyResponseDTO]
}

struct WritableReviewCompanyResponseDTO: Decodable {
    let companyID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case companyID = "id"
        case name
    }
}

extension WritableReviewListResponseDTO {
    func toDomain() -> [WritableReviewCompanyEntity] {
        companies.map {
            WritableReviewCompanyEntity(companyID: $0.companyID, name: $0.name)
        }
    }
}
