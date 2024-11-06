import Foundation

public struct RecruitmentDetailEntity: Equatable {
    public let recruitmentID: Int
    public let companyID: Int
    public let companyProfileURL: String
    public let companyName: String
    public let areas: [AreaEntity]
    public let additionalQualifications: String?
    public let workingHours: String
    public let requiredLicenses: String?
    public let hiringProgress: String
    public let trainPay: String
    public let pay: String?
    public let benefits: String?
    public let military: Bool?
    public let submitDocument: String
    public let period: String
    public let etc: String
    public let isApplicable: Bool
    public let winterIntern: Bool?
    public let hireConvertible: Bool?
    public let bookmarked: Bool
    public let integrationPlan: Bool?

    public init(
        recruitmentID: Int,
        companyID: Int,
        companyProfileURL: String,
        companyName: String,
        areas: [AreaEntity],
        additionalQualifications: String?,
        workingHours: String,
        requiredLicenses: String?,
        hiringProgress: String,
        trainPay: String,
        pay: String?,
        benefits: String?,
        military: Bool?,
        submitDocument: String,
        period: String,
        etc: String,
        isApplicable: Bool,
        winterIntern: Bool?,
        hireConvertible: Bool?,
        bookmarked: Bool,
        integrationPlan: Bool?
    ) {
        self.recruitmentID = recruitmentID
        self.companyID = companyID
        self.companyProfileURL = companyProfileURL
        self.companyName = companyName
        self.areas = areas
        self.additionalQualifications = additionalQualifications
        self.workingHours = workingHours
        self.requiredLicenses = requiredLicenses
        self.hiringProgress = hiringProgress
        self.trainPay = trainPay
        self.pay = pay
        self.benefits = benefits
        self.military = military
        self.submitDocument = submitDocument
        self.period = period
        self.etc = etc
        self.isApplicable = isApplicable
        self.winterIntern = winterIntern
        self.hireConvertible = hireConvertible
        self.bookmarked = bookmarked
        self.integrationPlan = integrationPlan
    }
}
