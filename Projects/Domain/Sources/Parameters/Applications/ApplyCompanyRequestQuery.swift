import Foundation

public struct ApplyCompanyRequestQuery: Encodable {
    public let attachments: [AttachmentsRequestQuery]

    public init(attachments: [AttachmentsRequestQuery]) {
        self.attachments = attachments
    }
}

public struct AttachmentsRequestQuery: Encodable {
    public let url: String
    public let type: AttachmentType

    public init(url: String, type: AttachmentType) {
        self.url = url
        self.type = type
    }
}
