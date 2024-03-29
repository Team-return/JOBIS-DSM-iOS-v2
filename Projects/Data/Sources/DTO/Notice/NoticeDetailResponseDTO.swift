import Foundation
import Domain
import Utility

struct NoticeDetailResponseDTO: Decodable {
    let title: String
    let content: String
    let createdAt: String
    let attachments: [AttachmentsResponseDTO]

    init(
        title: String,
        content: String,
        createdAt: String,
        attachments: [AttachmentsResponseDTO]
    ) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.attachments = attachments
    }

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case createdAt = "created_at"
        case attachments
    }
}

extension NoticeDetailResponseDTO {
    func toDomain() -> NoticeDetailEntity {
        let noticeDate = createdAt.toDateFormat("yyyy-MM-dd")
        return NoticeDetailEntity(
            title: title,
            content: content,
            createdAt: noticeDate.toStringFormat("yyyy-MM-dd"),
            attachments: attachments.map { $0.toDomain() }
        )
    }
}
