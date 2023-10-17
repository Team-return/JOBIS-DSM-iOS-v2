import Foundation
import Domain

public struct CompanyInfoDetailResponseDTO: Decodable {
    public let businessNumber: String
    public let companyName: String
    public let companyProfileURL: String
    public let companyIntroduce: String
    public let mainZipCode, mainAddress, mainAddressDetail: String
    public let subZipCode, subAddress, subAddressDetail: String?
    public let managerName, managerPhoneNo: String
    public let subManagerName, subManagerPhoneNo, fax: String?
    public let email, representativeName, foundedAt: String
    public let workerNumber: Int
    public let take: Double
    public let recruitmentID: Int?
    public let serviceName: String
    public let businessArea: String

    public init(
        businessNumber: String,
        companyName: String,
        companyProfileURL: String,
        companyIntroduce: String,
        mainZipCode: String,
        mainAddress: String,
        mainAddressDetail: String,
        subZipCode: String?,
        subAddress: String?,
        subAddressDetail: String?,
        managerName: String,
        managerPhoneNo: String,
        subManagerName: String?,
        subManagerPhoneNo: String?,
        fax: String?,
        email: String,
        representativeName: String,
        foundedAt: String,
        workerNumber: Int,
        take: Double,
        recruitmentID: Int?,
        serviceName: String,
        businessArea: String
    ) {
        self.businessNumber = businessNumber
        self.companyName = companyName
        self.companyProfileURL = companyProfileURL
        self.companyIntroduce = companyIntroduce
        self.mainZipCode = mainZipCode
        self.mainAddress = mainAddress
        self.mainAddressDetail = mainAddressDetail
        self.subZipCode = subZipCode
        self.subAddress = subAddress
        self.subAddressDetail = subAddressDetail
        self.managerName = managerName
        self.managerPhoneNo = managerPhoneNo
        self.subManagerName = subManagerName
        self.subManagerPhoneNo = subManagerPhoneNo
        self.fax = fax
        self.email = email
        self.representativeName = representativeName
        self.foundedAt = foundedAt
        self.workerNumber = workerNumber
        self.take = take
        self.recruitmentID = recruitmentID
        self.serviceName = serviceName
        self.businessArea = businessArea
    }

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
