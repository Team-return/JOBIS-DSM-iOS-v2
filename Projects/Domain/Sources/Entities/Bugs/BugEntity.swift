import Foundation

public struct BugEntity: Equatable, Hashable {
    public let id: Int
    public let title: String
    public let developmentArea: DevelopmentType
    public let createdAt: String

    public init(
        id: Int,
        title: String,
        developmentArea: DevelopmentType,
        createdAt: String
    ) {
        self.id = id
        self.title = title
        self.developmentArea = developmentArea
        self.createdAt = createdAt
    }
}
