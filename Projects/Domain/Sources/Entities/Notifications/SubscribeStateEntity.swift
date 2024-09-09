import Foundation

public struct SubscribeStateEntity: Equatable, Hashable {
    public let topic: NotificationType
    public let isSubscribed: Bool

    public init(
        topic: NotificationType,
        isSubscribed: Bool
    ) {
        self.topic = topic
        self.isSubscribed = isSubscribed
    }
}
