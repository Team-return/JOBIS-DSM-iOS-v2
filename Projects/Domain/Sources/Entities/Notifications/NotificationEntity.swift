import Foundation

public struct NotificationEntity: Equatable, Hashable {
    public let notificationID: Int
    public let title, content, topic: String
    public let detailID: Int
    public let createdAt: String
    public let new: Bool

    public init(
        notificationID: Int,
        title: String,
        content: String,
        topic: String,
        detailID: Int,
        createdAt: String,
        new: Bool
    ) {
        self.notificationID = notificationID
        self.title = title
        self.content = content
        self.topic = topic
        self.detailID = detailID
        self.createdAt = createdAt
        self.new = new
    }
}
