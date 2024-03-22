import Foundation

public struct AttachmentsEntity: Equatable, Hashable {
    public let url: String
    public let type: AttachmentType

    public init(url: String, type: AttachmentType) {
        self.url = url
        self.type = type
    }
}
