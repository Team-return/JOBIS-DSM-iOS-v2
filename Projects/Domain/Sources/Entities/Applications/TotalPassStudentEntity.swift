import Foundation

public struct TotalPassStudentEntity: Equatable {
    public let totalStudentCount, passedCount, approvedCount: Int

    public init(totalStudentCount: Int, passedCount: Int, approvedCount: Int) {
        self.totalStudentCount = totalStudentCount
        self.passedCount = passedCount
        self.approvedCount = approvedCount
    }
}
