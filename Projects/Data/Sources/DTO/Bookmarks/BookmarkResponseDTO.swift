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
