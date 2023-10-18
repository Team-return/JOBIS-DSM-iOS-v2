import Foundation
import Domain

public struct BookmarkListResponseDTO: Decodable {
    public let bookmarks: [BookmarkResponseDTO]

    public init(bookmarks: [BookmarkResponseDTO]) {
        self.bookmarks = bookmarks
    }
}

public struct BookmarkResponseDTO: Decodable {
    public let companyName: String
    public let recruitmentID: Int
    public let createdAt: String

    public init(
        companyName: String,
        recruitmentID: Int,
        createdAt: String
    ) {
        self.companyName = companyName
        self.recruitmentID = recruitmentID
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case recruitmentID = "recruitment_id"
        case createdAt = "created_at"
    }
}

public extension BookmarkListResponseDTO {
    func toDomain() -> [BookmarkEntity] {
        bookmarks.map {
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

            let inputDate = inputDateFormatter.date(from: $0.createdAt) ?? Date()
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd"

            let createdAt = outputDateFormatter.string(from: inputDate)

            return BookmarkEntity(
                companyName: $0.companyName,
                recruitmentID: $0.recruitmentID,
                createdAt: createdAt
            )
        }
    }
}
