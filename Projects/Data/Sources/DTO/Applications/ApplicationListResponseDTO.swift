import Foundation
import Domain

struct ApplicationListResponseDTO: Decodable {
    let applications: [ApplicationResponseDTO]
}

public struct ApplicationResponseDTO: Decodable {
    public let applicationID: Int
    public let company: String
    public let attachments: [AttachmentsResponseDTO]
    public let applicationStatus: ApplicationStatusType

    public init(
        applicationID: Int,
        company: String,
        attachments: [AttachmentsResponseDTO],
        applicationStatus: ApplicationStatusType
    ) {
        self.applicationID = applicationID
        self.company = company
        self.attachments = attachments
        self.applicationStatus = applicationStatus
    }

    enum CodingKeys: String, CodingKey {
        case applicationID = "application_id"
        case company
        case attachments
        case applicationStatus = "application_status"
    }
}

extension ApplicationListResponseDTO {
    func toDomain() -> [ApplicationEntity] {
        applications.map {
            ApplicationEntity(
                applicationID: $0.applicationID,
                company: $0.company,
                attachments: $0.attachments.map { $0.toDomain() },
                applicationStatus: $0.applicationStatus
            )
        }
    }
}
