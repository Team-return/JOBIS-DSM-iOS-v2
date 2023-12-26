import Foundation
import Domain

struct CompanyListResponseDTO: Decodable {
    let companies: [CompanyResponseDTO]
}

struct CompanyResponseDTO: Decodable {
    let companyID: Int
    let name: String
    let logoURL: String
    let take: Double
    let hasRecruitment: Bool

    enum CodingKeys: String, CodingKey {
        case companyID = "id"
        case name
        case logoURL = "logo_url"
        case take
        case hasRecruitment = "has_recruitment"
    }
}

extension CompanyListResponseDTO {
    func toDomain() -> [CompanyEntity] {
        companies.map {
            CompanyEntity(
                companyID: $0.companyID,
                name: $0.name,
                logoURL: $0.logoURL,
                take: $0.take,
                hasRecruitment: $0.hasRecruitment
            )
        }
    }
}
