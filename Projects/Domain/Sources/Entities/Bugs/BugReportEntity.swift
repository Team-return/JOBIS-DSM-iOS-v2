import Foundation

public struct BugReportEntity: Equatable, Hashable {
    public let bugID: Int
    public let title: String
    public let developmentArea: DevelopmentType
    public let createdAt: String

    public init(
        bugID: Int,
        title: String,
        developmentArea: DevelopmentType,
        createdAt: String
    ) {
        self.bugID = bugID
        self.title = title
        self.developmentArea = developmentArea
        self.createdAt = createdAt
    }
}
