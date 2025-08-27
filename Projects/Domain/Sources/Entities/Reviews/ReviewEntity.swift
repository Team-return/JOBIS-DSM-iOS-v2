import Foundation

public struct ReviewEntity: Equatable, Hashable {
    public let reviewID: Int
    public let companyName: String
    public let companyProfileURL: String
    public let year: Int
    public let writer: String
    public let major: String

    public init(reviewID: Int, companyName: String, companyProfileURL: String, year: Int, writer: String, major: String) {
        self.reviewID = reviewID
        self.companyName = companyName
        self.companyProfileURL = companyProfileURL
        self.year = year
        self.writer = writer
        self.major = major
    }
}
