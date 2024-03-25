import Foundation

public struct NoticeEntity: Equatable, Hashable {
    public let companyId: Int
    public let title: String
    public let createdAt: String

    public init(companyId: Int, title: String, createdAt: String) {
        self.companyId = companyId
        self.title = title
        self.createdAt = createdAt
    }
}
