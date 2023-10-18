import Domain

struct RecruitmentDetailResponseDTO: Decodable {
    let companyID: Int
    let companyProfileUrl: String
    let companyName: String
    let areas: [AreaResponseDTO]
    let preferentialTreatment: String?
    let requiredGrade: Int?
    let workHours: Int
    let requiredLicenses: [String]?
    let hiringProgress: [InterviewType]
    let trainPay: Int
    let pay: Int?
    let benefits: String?
    let military: Bool
    let submitDocument: String
    let startDate, endDate: String
    let etc: String?

    public init(
        companyID: Int,
        companyProfileUrl: String,
        companyName: String,
        areas: [AreaResponseDTO],
        preferentialTreatment: String?,
        requiredGrade: Int?,
        workHours: Int,
        requiredLicenses: [String]?,
        hiringProgress: [InterviewType],
        trainPay: Int,
        pay: Int?,
        benefits: String?,
        military: Bool,
        submitDocument: String,
        startDate: String,
        endDate: String,
        etc: String?
    ) {
        self.companyID = companyID
        self.companyProfileUrl = companyProfileUrl
        self.companyName = companyName
        self.areas = areas
        self.preferentialTreatment = preferentialTreatment
        self.requiredGrade = requiredGrade
        self.workHours = workHours
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

    enum CodingKeys: String, CodingKey {
        case companyID = "company_id"
        case companyProfileUrl = "company_profile_url"
        case companyName = "company_name"
        case areas
        case preferentialTreatment = "preferential_treatment"
        case requiredGrade = "required_grade"
        case workHours = "work_hours"
        case requiredLicenses = "required_licenses"
        case hiringProgress = "hiring_progress"
        case trainPay = "train_pay"
        case pay, benefits, military
        case submitDocument = "submit_document"
        case startDate = "start_date"
        case endDate = "end_date"
        case etc
    }
}

extension RecruitmentDetailResponseDTO {
    func toDomain() -> RecruitmentDetailEntity {
        var unwrappedRequiredGrade: String? {
            if let requiredGrade {
                return String(requiredGrade) + "% 이내"
            } else {
                return nil
            }
        }
        var unwrappedPay: String? {
            if let pay {
                return String(pay) + " 만원/년"
            } else {
                return nil
            }
        }
        return RecruitmentDetailEntity(
            companyID: companyID,
            companyProfileUrl: companyProfileUrl,
            companyName: companyName,
            areas: areas.map { $0.toDomain() },
            preferentialTreatment: preferentialTreatment,
            requiredGrade: unwrappedRequiredGrade,
            workHours: String(workHours),
            requiredLicenses: requiredLicenses?.joined(separator: ", "),
            hiringProgress: hiringProgress.enumerated().map { (index, value) in
                "\(index + 1). \(value.localizedString())"
            }.joined(separator: "\n"),
            trainPay: String(trainPay),
            pay: unwrappedPay,
            benefits: benefits,
            military: military,
            submitDocument: submitDocument,
            startDate: startDate,
            endDate: endDate,
            etc: etc ?? "없음"
        )
    }
}
