import Foundation

public struct BookmarkEntity: Equatable, Hashable {
    public let companyName: String
    public let recruitmentID: Int
    public let createdAt: String
    public let companyLogoUrl: String

    public init(
        companyName: String,
        recruitmentID: Int,
        createdAt: String,
        companyLogoUrl: String
    ) {
        self.companyName = companyName
        self.recruitmentID = recruitmentID
        self.createdAt = createdAt
        self.companyLogoUrl = companyLogoUrl
    }
}
