import Foundation

public struct ReviewListRequestQuery: Encodable {
    public let page: Int?
    public let location: String?
    public let type: String?
    public let companyID: Int?
    public let keyword: String?
    public let year: String?
    public let code: String?
    public let companyName: String?
    public let writer: String?

    public init(
        page: Int? = nil,
        location: String? = nil,
        type: String? = nil,
        companyID: Int? = nil,
        keyword: String? = nil,
        year: String? = nil,
        code: String? = nil,
        companyName: String? = nil,
        writer: String? = nil
    ) {
        self.page = page
        self.location = location
        self.type = type
        self.companyID = companyID
        self.keyword = keyword
        self.year = year
        self.code = code
        self.companyName = companyName
        self.writer = writer
    }

    enum CodingKeys: String, CodingKey {
        case page
        case location
        case type
        case companyID = "company_id"
        case keyword
        case year
        case code
        case companyName = "company_name"
        case writer
    }
}
