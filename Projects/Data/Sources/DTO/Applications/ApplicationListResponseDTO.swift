import Foundation
import Domain

struct ApplicationListResponseDTO: Decodable {
    let applications: [ApplicationResponseDTO]
}

public struct ApplicationResponseDTO: Decodable {
    public let applicationID: Int
    public let recruitmentID: Int
    public let company: String
    public let companyLogoUrl: String
    public let attachments: [AttachmentsResponseDTO]
    public let applicationStatus: ApplicationStatusType

    public init(
        applicationID: Int,
        recruitmentID: Int,
        company: String,
        companyLogoUrl: String,
        attachments: [AttachmentsResponseDTO],
        applicationStatus: ApplicationStatusType
    ) {
        self.applicationID = applicationID
        self.recruitmentID = recruitmentID
        self.company = company
        self.companyLogoUrl = companyLogoUrl
        self.attachments = attachments
        self.applicationStatus = applicationStatus
    }

    enum CodingKeys: String, CodingKey {
        case applicationID = "application_id"
        case recruitmentID = "recruitment_id"
        case company
        case companyLogoUrl = "company_logo_url"
        case attachments
        case applicationStatus = "application_status"
    }
}

extension ApplicationListResponseDTO {
    func toDomain() -> [ApplicationEntity] {
        applications.map {
            ApplicationEntity(
                applicationID: $0.applicationID,
                recruitmentID: $0.recruitmentID,
                company: $0.company,
                companyLogoUrl: $0.companyLogoUrl,
                attachments: $0.attachments.map { $0.toDomain() },
                applicationStatus: $0.applicationStatus
            )
        }
    }
}
