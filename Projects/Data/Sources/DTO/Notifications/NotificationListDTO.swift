import Foundation
import Domain

struct NotificationListResponseDTO: Codable {
    let notifications: [NotificationResponseDTO]
}

public struct NotificationResponseDTO: Codable {
    public let notificationID: Int
    public let title, content, topic: String
    public let detailID: Int
    public let createdAt: String
    public let new: Bool

    enum CodingKeys: String, CodingKey {
        case notificationID = "notification_id"
        case title, content, topic
        case detailID = "detail_id"
        case createdAt = "created_at"
        case new
    }
}

extension NotificationListResponseDTO {
    func toDomain() -> [NotificationEntity] {
        notifications.map {
            NotificationEntity(
                notificationID: $0.notificationID,
                title: $0.title,
                content: $0.content,
                topic: $0.topic,
                detailID: $0.detailID,
                createdAt: $0.createdAt.toJobisDate().toStringFormat("yyyy.MM.dd"),
                new: $0.new
            )
        }
    }
}
