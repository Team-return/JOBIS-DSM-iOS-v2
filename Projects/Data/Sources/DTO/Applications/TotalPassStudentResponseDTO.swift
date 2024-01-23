import Foundation
import Domain

public struct TotalPassStudentResponseDTO: Codable {
    public let totalStudentCount, passedCount, approvedCount: Int

    public init(totalStudentCount: Int, passedCount: Int, approvedCount: Int) {
        self.totalStudentCount = totalStudentCount
        self.passedCount = passedCount
        self.approvedCount = approvedCount
    }

    enum CodingKeys: String, CodingKey {
        case totalStudentCount = "total_student_count"
        case passedCount = "passed_count"
        case approvedCount = "approved_count"
    }
}

public extension TotalPassStudentResponseDTO {
    func toDomain() -> TotalPassStudentEntity {
        let totalStudentCount = totalStudentCount > 0 ? totalStudentCount: 1
        return TotalPassStudentEntity(
            totalStudentCount: totalStudentCount,
            passedCount: passedCount,
            approvedCount: approvedCount
        )
    }
}
