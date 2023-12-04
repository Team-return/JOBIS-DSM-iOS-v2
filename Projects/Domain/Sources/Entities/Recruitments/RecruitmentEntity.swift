import Foundation

public struct RecruitmentEntity: Equatable, Hashable {
    public let recruitID: Int
    public let companyName: String
    public let companyProfileURL: String
    public let trainPay: Int
    public let militarySupport: Bool
    public let hiringJobs: String
    public var bookmarked: Bool

    public init(
        recruitID: Int,
        companyName: String,
        companyProfileURL: String,
        trainPay: Int,
        militarySupport: Bool,
        hiringJobs: String,
        bookmarked: Bool
    ) {
        self.recruitID = recruitID
        self.companyName = companyName
        self.companyProfileURL = companyProfileURL
        self.trainPay = trainPay
        self.militarySupport = militarySupport
        self.hiringJobs = hiringJobs
        self.bookmarked = bookmarked
    }
}
