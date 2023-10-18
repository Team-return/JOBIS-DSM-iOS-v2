import Foundation
import Domain

public struct AttachmentsResponseDTO: Hashable, Decodable {
    public let url: String
    public let type: AttachmentType

    public init(url: String, type: AttachmentType) {
        self.url = url
        self.type = type
    }
}

public extension AttachmentsResponseDTO {
    func toDomain() -> AttachmentsEntity {
        AttachmentsEntity(
            url: url,
            type: type
        )
    }
}
