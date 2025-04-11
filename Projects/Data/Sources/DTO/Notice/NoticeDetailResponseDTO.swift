import Foundation
import Domain
import Utility

struct NoticeDetailResponseDTO: Decodable {
    let title: String
    let content: String
    let createdAt: String
    let attachments: [AttachmentsResponseDTO]?

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case createdAt = "created_at"
        case attachments
    }
}

extension NoticeDetailResponseDTO {
    func toDomain() -> NoticeDetailEntity {
        let noticeDate = createdAt.toJobisDate()

        return NoticeDetailEntity(
            title: title,
            content: content,
            createdAt: noticeDate.toStringFormat("yyyy-MM-dd"),
            attachments: attachments?
                .compactMap { $0.toDomain() } ?? []
        )
    }
}
