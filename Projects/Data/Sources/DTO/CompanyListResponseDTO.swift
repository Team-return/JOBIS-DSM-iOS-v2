import Foundation
import Domain

public struct CompanyListResponseDTO: Decodable {
    public let companies: [CompanyResponseDTO]

    public init(companies: [CompanyResponseDTO]) {
        self.companies = companies
    }
}

public struct CompanyResponseDTO: Decodable {
    public let id: Int
    public let name: String
    public let logoURL: String
    public let take: Double
    public let hasRecruitment: Bool

    public init(id: Int, name: String, logoURL: String, take: Double, hasRecruitment: Bool) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.take = take
        self.hasRecruitment = hasRecruitment
    }

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
