import Foundation
import Domain

struct FetchPresignedURLResponseDTO: Decodable {
    let urls: [URLsResponseDTO]
}

struct URLsResponseDTO: Decodable {
    let filePath: String
    let presignedUrl: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case presignedUrl = "pre_signed_url"
    }
}

extension FetchPresignedURLResponseDTO {
    func toDomain() -> [PresignedURLEntity] {
        self.urls.map {
            .init(filePath: $0.filePath, presignedUrl: $0.presignedUrl)
        }
    }
}
