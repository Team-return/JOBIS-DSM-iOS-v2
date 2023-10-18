import Foundation
import Domain

struct BookmarkListResponseDTO: Decodable {
    let bookmarks: [BookmarkResponseDTO]
}

struct BookmarkResponseDTO: Decodable {
    let companyName: String
    let recruitmentID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case recruitmentID = "recruitment_id"
        case createdAt = "created_at"
    }
}

extension BookmarkListResponseDTO {
    func toDomain() -> [BookmarkEntity] {
        bookmarks.map {
            BookmarkEntity(
                companyName: $0.companyName,
                recruitmentID: $0.recruitmentID,
                createdAt: $0.createdAt.toJobisDate().toSting()
            )
        }
    }
}
