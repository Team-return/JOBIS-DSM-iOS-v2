import Foundation
import Utility
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
            let noticeDate = $0.createdAt.toDateFormat("yyyy-MM-dd")
            return NoticeEntity(
                companyId: $0.id,
                title: $0.title,
                createdAt: noticeDate.toStringFormat("yyyy-MM-dd")
            )
        }
    }
}
