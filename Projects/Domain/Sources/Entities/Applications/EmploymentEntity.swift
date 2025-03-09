import Foundation

public struct EmploymentEntity: Equatable {
    public let classID: Int?
    public let employmentRateResponseList: [EmploymentCompany]?
    public let totalStudents: Int?
    public let passedStudents: Int?

    public static let empty = EmploymentEntity(
        classID: 0,
        employmentRateResponseList: [],
        totalStudents: 0,
        passedStudents: 0
    )

    public init(
        classID: Int? = nil,
        employmentRateResponseList: [EmploymentCompany]? = nil,
        totalStudents: Int? = nil,
        passedStudents: Int? = nil
    ) {
        self.classID = classID
        self.employmentRateResponseList = employmentRateResponseList
        self.totalStudents = totalStudents
        self.passedStudents = passedStudents
    }

    public func with(classID: Int) -> EmploymentEntity {
        EmploymentEntity(
            classID: classID,
            employmentRateResponseList: self.employmentRateResponseList,
            totalStudents: self.totalStudents,
            passedStudents: self.passedStudents
        )
    }
}

public struct EmploymentCompany: Equatable {
    public let id: Int
    public let companyName: String
    public let logoURL: String

    public static let empty = EmploymentCompany(
        id: 0,
        companyName: "",
        logoURL: ""
    )

    public init(
        id: Int,
        companyName: String,
        logoURL: String
    ) {
        self.id = id
        self.companyName = companyName
        self.logoURL = logoURL
    }
}
