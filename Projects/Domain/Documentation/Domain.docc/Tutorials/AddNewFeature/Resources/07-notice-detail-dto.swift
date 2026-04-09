import Foundation
import Domain
import Utility

// 서버 응답 JSON을 디코딩하는 구조체
struct NoticeDetailResponseDTO: Decodable {
    let title: String
    let content: String
    let createdAt: String           // snake_case → camelCase 변환
    let attachments: [AttachmentsResponseDTO]?

    enum CodingKeys: String, CodingKey {
        case title
        case content
        case createdAt = "created_at"
        case attachments
    }
}

extension NoticeDetailResponseDTO {
    // DTO → Domain Entity 변환
    func toDomain() -> NoticeDetailEntity {
        return NoticeDetailEntity(
            title: title,
            content: content,
            createdAt: createdAt.toJobisDate().toStringFormat("yyyy-MM-dd"),
            attachments: attachments?.compactMap { $0.toDomain() } ?? []
        )
    }
}
