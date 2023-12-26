import Foundation

public struct WritableReviewCompanyEntity: Equatable, Hashable {
    public let reviewID: Int
    public let name: String

    public init(reviewID: Int, name: String) {
        self.reviewID = reviewID
        self.name = name
    }
}
