import Foundation
import Domain

struct BugDetailResponseDTO: Decodable {
    let title: String
    let content: String
    let developmentArea: DevelopmentType
    let attachments: [String]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case title, content
        case developmentArea = "development_area"
        case attachments
        case createdAt = "created_at"
    }
}

extension BugDetailResponseDTO {
    func toDomain() -> BugDetailEntity {
        BugDetailEntity(
            title: title,
            content: content,
            developmentArea: developmentArea,
            attachments: attachments,
            createdAt: createdAt
        )
    }
}
