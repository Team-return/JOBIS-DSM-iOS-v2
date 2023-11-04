import Foundation
import Domain

struct CompanyListResponseDTO: Decodable {
    let companies: [CompanyResponseDTO]
}

struct CompanyResponseDTO: Decodable {
    let id: Int
    let name: String
    let logoURL: String
    let take: Double
    let hasRecruitment: Bool

    enum CodingKeys: String, CodingKey {
        case id
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
                id: $0.id,
                name: $0.name,
                logoURL: $0.logoURL,
                take: $0.take,
                hasRecruitment: $0.hasRecruitment
            )
        }
    }
}
