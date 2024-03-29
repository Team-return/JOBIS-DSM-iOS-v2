import Domain

struct ReviewListResponseDTO: Decodable {
    let reviews: [ReviewResponseDTO]
}

struct ReviewResponseDTO: Decodable {
    let reviewID: Int
    let year: Int
    let writer: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "review_id"
        case year
        case writer
        case date
    }
}

extension ReviewListResponseDTO {
    func toDomain() -> [ReviewEntity] {
        reviews.map {
            ReviewEntity(reviewID: $0.reviewID, year: $0.year, writer: $0.writer, date: $0.date)
        }
    }
}
