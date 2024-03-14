import Foundation
import Domain

struct FetchBannerListDTO: Codable {
    let banners: [FetchBannerDTO]
}

struct FetchBannerDTO: Codable {
    let id: Int
    let bannerURL: String
    let bannerType: String

    enum CodingKeys: String, CodingKey {
        case id
        case bannerURL = "banner_url"
        case bannerType = "banner_type"
    }
}

extension FetchBannerListDTO {
    func toDomain() -> [FetchBannerEntity] {
        banners.map {
            FetchBannerEntity(
                id: $0.id,
                bannerURL: $0.bannerURL,
                bannerType: $0.bannerType
            )
        }
    }
}
