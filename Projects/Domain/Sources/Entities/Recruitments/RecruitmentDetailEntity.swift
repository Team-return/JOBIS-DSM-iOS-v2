import Foundation

public struct RecruitmentDetailEntity: Equatable {
    public let companyID: Int
    public let companyProfileUrl: String
    public let companyName: String
    public let areas: [AreaEntity]
    public let requiredGrade: String?
    public let workTime: String
    public let requiredLicenses: String?
    public let hiringProgress: String
    public let trainPay: String
    public let pay: String?
    public let benefits: String?
    public let military: Bool
    public let submitDocument: String
    public let startDate, endDate: String
    public let etc: String

    public init(
        companyID: Int,
        companyProfileUrl: String,
        companyName: String,
        areas: [AreaEntity],
        requiredGrade: String?,
        workTime: String,
        requiredLicenses: String?,
        hiringProgress: String,
        trainPay: String,
        pay: String?,
        benefits: String?,
        military: Bool,
        submitDocument: String,
        startDate: String,
        endDate: String,
        etc: String
    ) {
        self.companyID = companyID
        self.companyProfileUrl = companyProfileUrl
        self.companyName = companyName
        self.areas = areas
        self.requiredGrade = requiredGrade
        self.workTime = workTime
        self.requiredLicenses = requiredLicenses
        self.hiringProgress = hiringProgress
        self.trainPay = trainPay
        self.pay = pay
        self.benefits = benefits
        self.military = military
        self.submitDocument = submitDocument
        self.startDate = startDate
        self.endDate = endDate
        self.etc = etc
    }
}
