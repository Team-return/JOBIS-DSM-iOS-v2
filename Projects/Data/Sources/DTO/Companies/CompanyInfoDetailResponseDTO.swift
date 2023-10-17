import Foundation
import Domain

struct CompanyInfoDetailResponseDTO: Decodable {
    let businessNumber: String
    let companyName: String
    let companyProfileURL: String
    let companyIntroduce: String
    let mainZipCode, mainAddress, mainAddressDetail: String
    let subZipCode, subAddress, subAddressDetail: String?
    let managerName, managerPhoneNo: String
    let subManagerName, subManagerPhoneNo, fax: String?
    let email, representativeName, foundedAt: String
    let workerNumber: Int
    let take: Double
    let recruitmentID: Int?
    let serviceName: String
    let businessArea: String

    enum CodingKeys: String, CodingKey {
        case businessNumber = "business_number"
        case companyName = "company_name"
        case companyProfileURL = "company_profile_url"
        case companyIntroduce = "company_introduce"
        case mainZipCode = "main_zip_code"
        case mainAddress = "main_address"
        case mainAddressDetail = "main_address_detail"
        case subZipCode = "sub_zip_code"
        case subAddress = "sub_address"
        case subAddressDetail = "sub_address_detail"
        case managerName = "manager_name"
        case managerPhoneNo = "manager_phone_no"
        case subManagerName = "sub_manager_name"
        case subManagerPhoneNo = "sub_manager_phone_no"
        case fax, email
        case representativeName = "representative_name"
        case foundedAt = "founded_at"
        case workerNumber = "worker_number"
        case take
        case recruitmentID = "recruitment_id"
        case serviceName = "service_name"
        case businessArea = "business_area"
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
            subZipCode: subZipCode ?? "없음",
            subAddress: subAddress ?? "없음",
            subAddressDetail: subAddressDetail ?? "없음",
            managerName: managerName,
            managerPhoneNo: managerPhoneNo,
            subManagerName: subManagerName ?? "없음",
            subManagerPhoneNo: subManagerPhoneNo ?? "없음",
            fax: fax ?? "없음",
            email: email,
            representativeName: representativeName,
            foundedAt: foundedAt,
            workerNumber: String(workerNumber) + "명",
            take: String(take) + "억원",
            recruitmentID: recruitmentID,
            serviceName: serviceName,
            businessArea: businessArea
        )
    }
}
