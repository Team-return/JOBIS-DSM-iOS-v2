import Foundation
import Domain

public struct WritableReviewListResponseDTO: Decodable {
    public let companies: [WritableReviewCompanyResponseDTO]

    public init(companies: [WritableReviewCompanyResponseDTO]) {
        self.companies = companies
    }
}

public struct WritableReviewCompanyResponseDTO: Decodable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension WritableReviewListResponseDTO {
    func toDomain() -> [WritableReviewCompanyEntity] {
        companies.map {
            WritableReviewCompanyEntity(id: $0.id, name: $0.name)
        }
    }
}
