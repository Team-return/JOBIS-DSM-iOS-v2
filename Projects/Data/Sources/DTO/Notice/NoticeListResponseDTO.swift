import Foundation
import Domain

struct NoticeListResponseDTO: Decodable {
    let notices: [NoticeResponseDTO]
}

struct NoticeResponseDTO: Decodable {
    let id: Int
    let title: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case createdAt = "created_at"
    }
}

extension NoticeListResponseDTO {
    func toDomain() -> [NoticeEntity] {
        notices.map {
            let noticeDate = String($0.createdAt.prefix(while: { $0 != "T" }))
            return NoticeEntity(
                companyId: $0.id,
                title: $0.title,
                createdAt: noticeDate
            )
        }
    }
}
