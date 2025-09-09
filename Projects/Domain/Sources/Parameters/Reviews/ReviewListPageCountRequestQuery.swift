import Foundation

public struct ReviewListPageCountRequestQuery: Encodable {
    public let location: LocationType?
    public let type: InterviewFormat?
    public let companyID: Int?
    public let year: Int?
    public let code: Int?

    public init(
        location: LocationType? = nil,
        type: InterviewFormat? = nil,
        companyID: Int? = nil,
        year: Int? = nil,
        code: Int? = nil
    ) {
        self.location = location
        self.type = type
        self.companyID = companyID
        self.year = year
        self.code = code
    }

    enum CodingKeys: String, CodingKey {
        case location
        case type
        case companyID = "company_id"
        case year
        case code
    }
}
