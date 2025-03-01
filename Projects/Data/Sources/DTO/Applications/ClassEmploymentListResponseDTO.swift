import Foundation
import Domain

public struct ClassEmploymentListResponseDTO: Decodable {
    let classes: [ClassEmploymentResponseDTO]
}

public struct ClassEmploymentResponseDTO: Decodable {
    public let classId: Int
    public let employmentRateResponseList: [EmploymentCompanyResponseDTO]
    public let totalStudents: Int
    public let passedStudents: Int

    public init(
        classId: Int,
        employmentRateResponseList: [EmploymentCompanyResponseDTO],
        totalStudents: Int,
        passedStudents: Int
    ) {
        self.classId = classId
        self.employmentRateResponseList = employmentRateResponseList
        self.totalStudents = totalStudents
        self.passedStudents = passedStudents
    }

    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case employmentRateResponseList = "employment_rate_response_list"
        case totalStudents = "total_students"
        case passedStudents = "passed_students"
    }
}

public struct EmploymentCompanyResponseDTO: Decodable {
    public let id: Int
    public let companyName: String
    public let logoUrl: String

    public init(
        id: Int,
        companyName: String,
        logoUrl: String
    ) {
        self.id = id
        self.companyName = companyName
        self.logoUrl = logoUrl
    }

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case logoUrl = "logo_url"
    }
}

extension ClassEmploymentListResponseDTO {
    func toDomain() -> [ApplicationEntity] {
        classes.map {
            ApplicationEntity(
                applicationID: 0,
                recruitmentID: 0,
                company: "",
                companyLogoUrl: "",
                attachments: [],
                applicationStatus: .approved,
                classId: $0.classId,
                employmentRateResponseList: $0.employmentRateResponseList.map { company in
                    EmploymentCompany(
                        id: company.id,
                        companyName: company.companyName,
                        logoUrl: company.logoUrl
                    )
                },
                totalStudents: $0.totalStudents,
                passedStudents: $0.passedStudents
            )
        }
    }
}
