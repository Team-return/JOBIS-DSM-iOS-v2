import Foundation
import Domain

public struct InterestResponseDTO: Decodable {
    public let id: Int
    public let studentID: Int
    public let code: Int
    public let keyword: String
    
    public init(
        id: Int,
        studentID: Int,
        code: Int,
        keyword: String
    ) {
        self.id = id
        self.studentID = studentID
        self.code = code
        self.keyword = keyword
    }

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case code
        case keyword
    }
}

extension Array where Element == InterestResponseDTO {
    func toDomain() -> [InterestsEntity] {
        self.map {
            InterestsEntity(
                interestID: $0.id,
                studentID: $0.studentID,
                code: $0.code,
                keyword: $0.keyword
            )
        }
    }
}
