import Foundation

public struct ReviewEntity: Equatable, Hashable {
    public let reviewID: Int
    public let year: Int
    public let writer: String

    public init(reviewID: Int, year: Int, writer: String) {
        self.reviewID = reviewID
        self.year = year
        self.writer = writer
    }
}
