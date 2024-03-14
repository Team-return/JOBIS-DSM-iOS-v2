import Foundation

public struct ReviewEntity: Equatable, Hashable {
    public let reviewID: Int
    public let year: Int
    public let writer: String
    public let date: String

    public init(reviewID: Int, year: Int, writer: String, date: String) {
        self.reviewID = reviewID
        self.year = year
        self.writer = writer
        self.date = date
    }
}
