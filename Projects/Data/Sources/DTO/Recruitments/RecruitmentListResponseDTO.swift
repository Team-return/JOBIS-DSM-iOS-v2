import Domain

struct RecruitmentListResponseDTO: Decodable {
    let recruitments: [RecruitmentResponseDTO]
}

struct RecruitmentResponseDTO: Codable {
    let recruitID: Int
    let companyName: String
    let companyProfileURL: String
    let trainPay: Int
    let militarySupport: Bool
    let hiringJobs: String
    let bookmarked: Bool

    enum CodingKeys: String, CodingKey {
        case recruitID = "id"
        case companyName = "company_name"
        case companyProfileURL = "company_profile_url"
        case trainPay = "train_pay"
        case militarySupport = "military_support"
        case hiringJobs = "hiring_jobs"
        case bookmarked
    }
}

extension RecruitmentListResponseDTO {
    func toDomain() -> [RecruitmentEntity] {
        recruitments.map {
            RecruitmentEntity(
                recruitID: $0.recruitID,
                companyName: $0.companyName,
                companyProfileURL: $0.companyProfileURL,
                trainPay: $0.trainPay,
                militarySupport: $0.militarySupport,
                hiringJobs: $0.hiringJobs,
                bookmarked: $0.bookmarked
            )
        }
    }
}
