import Foundation
import Domain

public struct ReviewListResponseDTO: Decodable {
    public let reviews: [ReviewItemResponseDTO]

    public init(reviews: [ReviewItemResponseDTO]) {
        self.reviews = reviews
    }
}

public struct ReviewItemResponseDTO: Decodable {
    public let reviewID: Int
    public let companyName: String
    public let companyLogoURL: String
    public let year: Int
    public let writer: String
    public let major: String

    public init(
        reviewID: Int,
        companyName: String,
        companyLogoURL: String,
        year: Int,
        writer: String,
        major: String
    ) {
        self.reviewID = reviewID
        self.companyName = companyName
        self.companyLogoURL = companyLogoURL
        self.year = year
        self.writer = writer
        self.major = major
    }

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case companyName = "company_name"
        case companyLogoURL = "company_logo_url"
        case year
        case writer
        case major
    }
}

public extension ReviewListResponseDTO {
    func toDomain() -> [ReviewEntity] {
        reviews.map { $0.toDomain() }
    }
}

public extension ReviewItemResponseDTO {
    func toDomain() -> ReviewEntity {
        ReviewEntity(
            reviewID: reviewID,
            year: year,
            writer: writer,
            date: ""
        )
    }
}
