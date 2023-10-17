import Foundation
import Domain

public struct StudentInfoResponseDTO: Decodable {
    public let studentName: String
    public let studentGcn: String
    public let department: DepartmentType
    public let profileImageUrl: String

    public init(
        studentName: String,
        studentGcn: String,
        department: DepartmentType,
        profileImageUrl: String
    ) {
        self.studentName = studentName
        self.studentGcn = studentGcn
        self.department = department
        self.profileImageUrl = profileImageUrl
    }

    enum CodingKeys: String, CodingKey {
        case studentName = "student_name"
        case studentGcn = "student_gcn"
        case department
        case profileImageUrl = "profile_image_url"
    }
}

public extension StudentInfoResponseDTO {
    func toDomain() -> StudentInfoEntity {
        StudentInfoEntity(
            studentName: studentName,
            studentGcn: studentGcn,
            department: department,
            profileImageUrl: profileImageUrl
        )
    }
}
