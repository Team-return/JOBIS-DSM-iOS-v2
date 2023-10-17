import Foundation
import Domain

struct StudentInfoResponseDTO: Decodable {
    let studentName: String
    let studentGcn: String
    let department: DepartmentType
    let profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case studentName = "student_name"
        case studentGcn = "student_gcn"
        case department
        case profileImageUrl = "profile_image_url"
    }
}

extension StudentInfoResponseDTO {
    func toDomain() -> StudentInfoEntity {
        StudentInfoEntity(
            studentName: studentName,
            studentGcn: studentGcn,
            department: department,
            profileImageUrl: profileImageUrl
        )
    }
}
