import Foundation
import Domain

public struct ClassEmploymentListResponseDTO: Decodable {
    let classes: [ClassEmploymentResponseDTO]
}

public struct ClassEmploymentResponseDTO: Decodable {
    public let classID: Int
    public let employmentRateResponseList: [EmploymentCompanyResponseDTO]
    public let totalStudents: Int
    public let passedStudents: Int

    public init(
        classID: Int,
        employmentRateResponseList: [EmploymentCompanyResponseDTO],
        totalStudents: Int,
        passedStudents: Int
    ) {
        self.classID = classID
        self.employmentRateResponseList = employmentRateResponseList
        self.totalStudents = totalStudents
        self.passedStudents = passedStudents
    }

    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case employmentRateResponseList = "employment_rate_response_list"
        case totalStudents = "total_students"
        case passedStudents = "passed_students"
    }
}

public struct EmploymentCompanyResponseDTO: Decodable {
    public let id: Int
    public let companyName: String
    public let logoURL: String

    public init(
        id: Int,
        companyName: String,
        logoURL: String
    ) {
        self.id = id
        self.companyName = companyName
        self.logoURL = logoURL
    }

    enum CodingKeys: String, CodingKey {
        case id
        case companyName = "company_name"
        case logoURL = "logo_url"
    }
}

extension ClassEmploymentListResponseDTO {
    func toDomain() -> [EmploymentEntity] {
        classes.map { $0.toDomain() }
    }
}

extension ClassEmploymentResponseDTO {
    func toDomain() -> EmploymentEntity {
        EmploymentEntity(
            classID: classID,
            employmentRateResponseList: employmentRateResponseList.map { $0.toDomain() },
            totalStudents: totalStudents,
            passedStudents: passedStudents
        )
    }
}

extension EmploymentCompanyResponseDTO {
    func toDomain() -> EmploymentCompany {
        EmploymentCompany(
            id: id,
            companyName: companyName,
            logoURL: logoURL
        )
    }
}
