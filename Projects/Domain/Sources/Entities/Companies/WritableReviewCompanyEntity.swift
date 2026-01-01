import Foundation

public struct WritableReviewCompanyEntity: Equatable, Hashable {
    public let companyID: Int
    public let name: String

    public init(companyID: Int, name: String) {
        self.companyID = companyID
        self.name = name
    }
}
