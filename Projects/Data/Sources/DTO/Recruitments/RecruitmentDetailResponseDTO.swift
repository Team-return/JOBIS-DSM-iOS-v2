import Foundation
import Domain

struct RecruitmentDetailResponseDTO: Decodable {
    let recruitmentID: Int
    let companyID: Int
    let companyProfileUrl: String
    let companyName: String
    let areas: [AreaResponseDTO]
    let requiredGrade: Int?
    let workingHours: String
    let requiredLicenses: [String]?
    let hiringProgress: [InterviewType]
    let trainPay: Int
    let pay: String?
    let benefits: String?
    let military: Bool
    let submitDocument: String
    let startDate, endDate: String
    let etc: String?
    let isApplicable: Bool
    let bookmarked: Bool

    init(
        recruitmentID: Int,
        companyID: Int,
        companyProfileUrl: String,
        companyName: String,
        areas: [AreaResponseDTO],
        requiredGrade: Int?,
        workingHours: String,
        requiredLicenses: [String]?,
        hiringProgress: [InterviewType],
        trainPay: Int,
        pay: String?,
        benefits: String?,
        military: Bool,
        submitDocument: String,
        startDate: String,
        endDate: String,
        etc: String?,
        isApplicable: Bool,
        bookmarked: Bool
    ) {
        self.recruitmentID = recruitmentID
        self.companyID = companyID
        self.companyProfileUrl = companyProfileUrl
        self.companyName = companyName
        self.areas = areas
        self.requiredGrade = requiredGrade
        self.workingHours = workingHours
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
        self.isApplicable = isApplicable
        self.bookmarked = bookmarked
    }

    enum CodingKeys: String, CodingKey {
        case recruitmentID = "recruitment_id"
        case companyID = "company_id"
        case companyProfileUrl = "company_profile_url"
        case companyName = "company_name"
        case areas
        case requiredGrade = "required_grade"
        case requiredLicenses = "required_licenses"
        case hiringProgress = "hiring_progress"
        case trainPay = "train_pay"
        case pay, benefits, military
        case submitDocument = "submit_document"
        case workingHours = "working_hours"
        case startDate = "start_date"
        case endDate = "end_date"
        case etc
        case isApplicable = "is_applicable"
        case bookmarked
    }
}

extension RecruitmentDetailResponseDTO {
    func toDomain() -> RecruitmentDetailEntity {
        var unwrappedRequiredGrade: String? {
            guard let requiredGrade else { return nil }
            return String(requiredGrade) + "% 이내"
        }
        return RecruitmentDetailEntity(
            recruitmentID: recruitmentID,
            companyID: companyID,
            companyProfileUrl: companyProfileUrl,
            companyName: companyName,
            areas: areas.map { $0.toDomain() },
            requiredGrade: unwrappedRequiredGrade,
            workingHours: workingHours,
            requiredLicenses: requiredLicenses?.joined(separator: ", "),
            hiringProgress: hiringProgress.enumerated().map { (index, value) in
                "\(index + 1). \(value.localizedString())"
            }.joined(separator: "\n"),
            trainPay: String(trainPay),
            pay: pay,
            benefits: benefits,
            military: military,
            submitDocument: submitDocument,
            startDate: startDate,
            endDate: endDate,
            etc: etc ?? "없음",
            isApplicable: isApplicable,
            bookmarked: bookmarked
        )
    }
}
