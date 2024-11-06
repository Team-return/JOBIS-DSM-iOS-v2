import Foundation
import Domain

struct CompanyInfoDetailResponseDTO: Decodable {
    let businessNumber: String
    let companyName: String
    let companyProfileURL: String
    let companyIntroduce: String
    let mainZipCode, mainAddress, mainAddressDetail: String
    let managerName: String
    let managerPhoneNo: String
    let email, representativeName , foundedAt: String
    let representativePhoneNo: String?
    let workerNumber: Int
    let take: Double
    let recruitmentID: Int?
    let attachments: [String]
    let serviceName: String
    let businessArea: String
    let headquarter: Bool

    enum CodingKeys: String, CodingKey {
        case businessNumber = "business_number"
        case companyName = "company_name"
        case companyProfileURL = "company_profile_url"
        case companyIntroduce = "company_introduce"
        case mainZipCode = "main_zip_code"
        case mainAddress = "main_address"
        case mainAddressDetail = "main_address_detail"
        case managerName = "manager_name"
        case managerPhoneNo = "manager_phone_no"
        case email
        case representativeName = "representative_name"
        case representativePhoneNo = "representative_phone_no"
        case foundedAt = "founded_at"
        case workerNumber = "worker_number"
        case take
        case recruitmentID = "recruitment_id"
        case attachments
        case serviceName = "service_name"
        case businessArea = "business_area"
        case headquarter
    }
}

extension CompanyInfoDetailResponseDTO {
    func toDomain() -> CompanyInfoDetailEntity {
        return CompanyInfoDetailEntity(
            businessNumber: businessNumber,
            companyName: companyName,
            companyProfileURL: companyProfileURL,
            companyIntroduce: companyIntroduce,
            mainZipCode: mainZipCode,
            mainAddress: mainAddress,
            mainAddressDetail: mainAddressDetail,
            managerName: managerName,
            managerPhoneNo: managerPhoneNo,
            email: email,
            representativeName: representativeName,
            representativePhoneNo: representativePhoneNo,
            foundedAt: foundedAt,
            workerNumber: String(workerNumber) + "명",
            take: String(take) + "억원",
            recruitmentID: recruitmentID,
            attachments: attachments,
            serviceName: serviceName,
            businessArea: businessArea,
            headquarter: headquarter
        )
    }
}
