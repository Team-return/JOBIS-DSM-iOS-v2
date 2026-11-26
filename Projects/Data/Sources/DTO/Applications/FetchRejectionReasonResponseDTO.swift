import Foundation
import Domain

public struct FetchRejectionReasonResponseDTO: Decodable {
    public let rejectionReason: String
    public let rejectionAttachments: [RejectionAttachmentResponseDTO]

    public init(
        rejectionReason: String,
        rejectionAttachments: [RejectionAttachmentResponseDTO] = []
    ) {
        self.rejectionReason = rejectionReason
        self.rejectionAttachments = rejectionAttachments
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rejectionReason = try container.decode(String.self, forKey: .rejectionReason)
        self.rejectionAttachments = try container.decodeIfPresent(
            [RejectionAttachmentResponseDTO].self,
            forKey: .rejectionAttachments
        ) ?? []
    }

    enum CodingKeys: String, CodingKey {
        case rejectionReason = "rejection_reason"
        case rejectionAttachments = "rejection_attachments"
    }
}

public struct RejectionAttachmentResponseDTO: Decodable {
    public let attachmentURL: String

    public init(attachmentURL: String) {
        self.attachmentURL = attachmentURL
    }

    enum CodingKeys: String, CodingKey {
        case attachmentURL = "attachment_url"
    }
}

public extension FetchRejectionReasonResponseDTO {
    func toDomain() -> RejectionEntity {
        RejectionEntity(
            reason: rejectionReason,
            attachments: rejectionAttachments.map {
                AttachmentsEntity(url: $0.attachmentURL, type: .file)
            }
        )
    }
}
