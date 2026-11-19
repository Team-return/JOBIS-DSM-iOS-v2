import Foundation

public struct RejectionEntity: Equatable {
    public let reason: String
    public let attachments: [AttachmentsEntity]

    public init(reason: String, attachments: [AttachmentsEntity]) {
        self.reason = reason
        self.attachments = attachments
    }
}
