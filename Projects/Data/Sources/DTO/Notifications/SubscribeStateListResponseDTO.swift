import Foundation
import Domain

struct SubscribeStateListResponseDTO: Codable {
    let topics: [SubscribeStateResponseDTO]
}

public struct SubscribeStateResponseDTO: Codable {
    let topic: NotificationType
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case topic
        case isSubscribed = "subscribed"
    }
}

extension SubscribeStateListResponseDTO {
        func toDomain() -> [SubscribeStateEntity] {
            topics.map {
                return SubscribeStateEntity.init(
                    topic: $0.topic,
                    isSubscribed: $0.isSubscribed
                )
            }
        }
}
