import Foundation

public struct ReviewListPageCountResponseDTO: Decodable {
    public let totalPageCount: Int

    public init(totalPageCount: Int) {
        self.totalPageCount = totalPageCount
    }

    enum CodingKeys: String, CodingKey {
        case totalPageCount = "total_page_count"
    }
}
