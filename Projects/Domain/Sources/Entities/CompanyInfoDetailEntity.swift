import Foundation

public struct CompanyInfoDetailEntity: Equatable {
    public let businessNumber: String
    public let companyName: String
    public let companyProfileURL: String
    public let companyIntroduce: String
    public let mainZipCode, mainAddress, mainAddressDetail: String
    public let subZipCode, subAddress, subAddressDetail: String?
    public let managerName, managerPhoneNo: String
    public let subManagerName, subManagerPhoneNo, fax: String?
    public let email, representativeName, foundedAt: String
    public let workerNumber: String
    public let take: String
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
        workerNumber: String,
        take: String,
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
}
