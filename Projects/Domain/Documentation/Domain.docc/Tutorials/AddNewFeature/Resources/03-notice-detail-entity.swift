import Foundation

public struct NoticeDetailEntity: Equatable, Hashable {
    public let title: String
    public let content: String
    public let createdAt: String
    public let attachments: [AttachmentsEntity]

    public init(title: String, content: String, createdAt: String, attachments: [AttachmentsEntity]) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.attachments = attachments
    }
}
