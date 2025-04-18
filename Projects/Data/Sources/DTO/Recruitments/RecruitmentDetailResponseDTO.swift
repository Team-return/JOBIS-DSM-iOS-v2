import Foundation
import Domain

struct RecruitmentDetailResponseDTO: Decodable {
    let recruitmentID: Int
    let companyID: Int
    let companyProfileURL: String?
    let companyName: String
    let areas: [AreaResponseDTO]
    let additionalQualifications: String?
    let workingHours: String
    let requiredLicenses: [String]?
    let hiringProgress: [InterviewType]
    let trainPay: Int?
    let pay: String?
    let benefits: String?
    let military: Bool?
    let submitDocument: String
    let startDate, endDate: String?
    let etc: String?
    let isApplicable: Bool
    let winterIntern: Bool?
    let hireConvertible: Bool?
    let bookmarked: Bool
    let integrationPlan: Bool?

    init(
        recruitmentID: Int,
        companyID: Int,
        companyProfileURL: String?,
        companyName: String,
        areas: [AreaResponseDTO],
        additionalQualifications: String?,
        workingHours: String,
        requiredLicenses: [String]?,
        hiringProgress: [InterviewType],
        trainPay: Int,
        pay: String?,
        benefits: String?,
        military: Bool?,
        submitDocument: String,
        startDate: String?,
        endDate: String?,
        etc: String?,
        isApplicable: Bool,
        winterIntern: Bool?,
        hireConvertible: Bool?,
        bookmarked: Bool,
        integrationPlan: Bool?
    ) {
        self.recruitmentID = recruitmentID
        self.companyID = companyID
        self.companyProfileURL = companyProfileURL ?? ""
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
        self.startDate = startDate
        self.endDate = endDate
        self.etc = etc
        self.isApplicable = isApplicable
        self.winterIntern = winterIntern
        self.hireConvertible = hireConvertible
        self.bookmarked = bookmarked
        self.integrationPlan = integrationPlan
    }

    enum CodingKeys: String, CodingKey {
        case recruitmentID = "recruitment_id"
        case companyID = "company_id"
        case companyProfileURL = "company_profile_url"
        case companyName = "company_name"
        case areas
        case additionalQualifications = "additional_qualifications"
        case requiredLicenses = "required_licenses"
        case hiringProgress = "hiring_progress"
        case trainPay = "train_pay"
        case pay, benefits
        case military = "military_support"
        case submitDocument = "submit_document"
        case workingHours = "working_hours"
        case startDate = "start_date"
        case endDate = "end_date"
        case etc
        case isApplicable = "is_applicable"
        case winterIntern = "winter_intern"
        case hireConvertible = "hire_convertible"
        case bookmarked
        case integrationPlan = "integration_plan"
    }
}

extension RecruitmentDetailResponseDTO {
    func toDomain() -> RecruitmentDetailEntity {
        var recruitmentPeriod: String {
            guard let startDate, let endDate else { return "상시 모집" }
            return "\(startDate) ~ \(endDate)"
        }

        return RecruitmentDetailEntity(
            recruitmentID: recruitmentID,
            companyID: companyID,
            companyProfileURL: companyProfileURL ?? "",
            companyName: companyName,
            areas: areas.map { $0.toDomain() },
            additionalQualifications: additionalQualifications,
            workingHours: workingHours,
            requiredLicenses: requiredLicenses?.joined(separator: ", "),
            hiringProgress: hiringProgress.enumerated().map { (index, value) in
                "\(index + 1). \(value.localizedString())"
            }.joined(separator: "\n"),
            trainPay: String(trainPay ?? 0),
            pay: pay,
            benefits: benefits,
            military: military,
            submitDocument: submitDocument,
            period: recruitmentPeriod,
            etc: etc ?? "없음",
            isApplicable: isApplicable,
            winterIntern: winterIntern,
            hireConvertible: hireConvertible,
            bookmarked: bookmarked,
            integrationPlan: integrationPlan
        )
    }
}
