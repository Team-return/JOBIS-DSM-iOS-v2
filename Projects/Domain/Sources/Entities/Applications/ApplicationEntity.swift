import Foundation

public struct ApplicationEntity: Equatable {
    public let applicationID, recruitmentID: Int
    public let company, companyLogoUrl: String
    public let attachments: [AttachmentsEntity]
    public let applicationStatus: ApplicationStatusType
    public let classId: Int?
    public let employmentRateResponseList: [EmploymentCompany]?
    public let totalStudents, passedStudents: Int?

    public init(
        applicationID: Int,
        recruitmentID: Int,
        company: String,
        companyLogoUrl: String,
        attachments: [AttachmentsEntity],
        applicationStatus: ApplicationStatusType,
        classId: Int? = nil,
        employmentRateResponseList: [EmploymentCompany]? = nil,
        totalStudents: Int? = nil,
        passedStudents: Int? = nil
    ) {
        self.applicationID = applicationID
        self.recruitmentID = recruitmentID
        self.company = company
        self.companyLogoUrl = companyLogoUrl
        self.attachments = attachments
        self.applicationStatus = applicationStatus
        self.classId = classId
        self.employmentRateResponseList = employmentRateResponseList
        self.totalStudents = totalStudents
        self.passedStudents = passedStudents
    }
}

public struct EmploymentCompany: Equatable {
    public let id: Int
    public let companyName, logoUrl: String

    public init(
        id: Int,
        companyName: String,
        logoUrl: String
    ) {
        self.id = id
        self.companyName = companyName
        self.logoUrl = logoUrl
    }
}
