import Foundation
import Domain

public struct RecentCompanyListResponseDTO: Decodable {
    public let companies: [RecentCompanyResponseDTO]
}

public struct RecentCompanyResponseDTO: Decodable {
    public let companyID: Int
    public let companyName: String
    public let companyLogoURL: String
    public let isRecruiting: Bool

    enum CodingKeys: String, CodingKey {
        case companyID = "company_id"
        case companyName = "company_name"
        case companyLogoURL = "company_logo_url"
        case isRecruiting = "is_recruiting"
    }
}

extension RecentCompanyResponseDTO {
    func toDomain() -> RecentCompanyEntity {
        return RecentCompanyEntity(
            companyID: companyID,
            companyName: companyName,
            companyLogoURL: companyLogoURL,
            isRecruiting: isRecruiting
        )
    }
}
