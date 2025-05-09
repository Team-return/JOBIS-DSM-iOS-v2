import Foundation
import Domain

struct InterestsResponseDTO: Decodable {
    let studentName: String
    let interests: [InterestResponseDTO]

    enum CodingKeys: String, CodingKey {
        case studentName = "student_name"
        case interests
    }
}

struct InterestResponseDTO: Decodable {
    let id: Int
    let studentID: Int
    let code: Int
    let keyword: String

    enum CodingKeys: String, CodingKey {
        case id
        case studentID = "student_id"
        case code
        case keyword
    }
}

extension InterestsResponseDTO {
    func toDomain() -> [InterestsEntity] {
        return interests.map {
            InterestsEntity(
                studentName: studentName,
                interestID: $0.id,
                studentID: $0.studentID,
                code: $0.code,
                keyword: $0.keyword
            )
        }
    }
}
