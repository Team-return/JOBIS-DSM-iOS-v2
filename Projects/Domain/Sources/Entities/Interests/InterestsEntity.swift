import Foundation

public struct InterestsEntity: Equatable {
    public let studentName: String
    public let interestID: Int
    public let studentID: Int
    public let code: Int
    public let keyword: String

    public init(
        studentName: String,
        interestID: Int,
        studentID: Int,
        code: Int,
        keyword: String
    ) {
        self.studentName = studentName
        self.interestID = interestID
        self.studentID = studentID
        self.code = code
        self.keyword = keyword
    }
}
