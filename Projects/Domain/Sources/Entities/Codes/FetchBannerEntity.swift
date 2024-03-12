import Foundation

public struct FetchBannerEntity: Equatable {
    public let id: Int
    public let bannerURL: String
    public let bannerType: String

    public init(
        id: Int,
        bannerURL: String,
        bannerType: String
    ) {
        self.id = id
        self.bannerURL = bannerURL
        self.bannerType = bannerType
    }
}
