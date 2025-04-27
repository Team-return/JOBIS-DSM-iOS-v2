import Foundation

public struct InterestsEntity: Equatable {
    public let interestID: Int
    public let studentID: Int
    public let code: Int
    public let keyword: String

    public init(
        interestID: Int,
        studentID: Int,
        code: Int,
        keyword: String
    ) {
        self.interestID = interestID
        self.studentID = studentID
        self.code = code
        self.keyword = keyword
    }
}
