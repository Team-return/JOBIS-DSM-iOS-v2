import Foundation

public struct StudentInfoEntity: Equatable {
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
}
