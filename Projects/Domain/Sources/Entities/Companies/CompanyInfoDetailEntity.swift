import Foundation

public struct CompanyInfoDetailEntity: Equatable {
    public let businessNumber: String
    public let companyName: String
    public let companyProfileURL: String
    public let companyIntroduce: String
    public let mainZipCode, mainAddress, mainAddressDetail: String
    public let managerName: String
    public let managerPhoneNo: String
    public let email, representativeName, foundedAt: String
    public let representativePhoneNo: String?
    public let workerNumber: String
    public let take: String
    public let recruitmentID: Int?
    public let attachments: [String]
    public let serviceName: String
    public let businessArea: String
    public let headquarter: Bool

    public init(
        businessNumber: String,
        companyName: String,
        companyProfileURL: String,
        companyIntroduce: String,
        mainZipCode: String,
        mainAddress: String,
        mainAddressDetail: String,
        managerName: String,
        managerPhoneNo: String,
        email: String,
        representativeName: String,
        representativePhoneNo: String?,
        foundedAt: String,
        workerNumber: String,
        take: String,
        recruitmentID: Int?,
        attachments: [String],
        serviceName: String,
        businessArea: String,
        headquarter: Bool
    ) {
        self.businessNumber = businessNumber
        self.companyName = companyName
        self.companyProfileURL = companyProfileURL
        self.companyIntroduce = companyIntroduce
        self.mainZipCode = mainZipCode
        self.mainAddress = mainAddress
        self.mainAddressDetail = mainAddressDetail
        self.managerName = managerName
        self.managerPhoneNo = managerPhoneNo
        self.email = email
        self.representativeName = representativeName
        self.representativePhoneNo = representativePhoneNo
        self.foundedAt = foundedAt
        self.workerNumber = workerNumber
        self.take = take
        self.recruitmentID = recruitmentID
        self.attachments = attachments
        self.serviceName = serviceName
        self.businessArea = businessArea
        self.headquarter = headquarter
    }
}
