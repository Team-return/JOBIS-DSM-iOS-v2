import Foundation

public struct CompanyEntity: Equatable, Hashable {
    public let companyID: Int
    public let name: String
    public let logoURL: String
    public let take: Double
    public let hasRecruitment: Bool

    public init(
        companyID: Int,
        name: String,
        logoURL: String,
        take: Double,
        hasRecruitment: Bool
    ) {
        self.companyID = companyID
        self.name = name
        self.logoURL = logoURL
        self.take = take
        self.hasRecruitment = hasRecruitment
    }
}
