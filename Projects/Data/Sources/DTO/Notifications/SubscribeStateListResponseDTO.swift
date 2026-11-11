import Foundation
import Domain

struct SubscribeStateListResponseDTO: Codable {
    let topics: [SubscribeStateResponseDTO]
}

public struct SubscribeStateResponseDTO: Codable {
    let topic: String
    let isSubscribed: Bool

    enum CodingKeys: String, CodingKey {
        case topic
        case isSubscribed = "subscribed"
    }
}

extension SubscribeStateListResponseDTO {
        func toDomain() -> [SubscribeStateEntity] {
            topics.compactMap {
                guard let topic = NotificationType(rawValue: $0.topic) else { return nil }
                return SubscribeStateEntity.init(
                    topic: topic,
                    isSubscribed: $0.isSubscribed
                )
            }
        }
}
