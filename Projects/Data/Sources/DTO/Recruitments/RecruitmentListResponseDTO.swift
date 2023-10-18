import Domain

struct RecruitmentListResponseDTO: Decodable {
    let recruitments: [RecruitmentResponseDTO]
}

struct RecruitmentResponseDTO: Decodable {
    let recruitID: Int
    let companyName: String
    let companyProfileURL: String
    let trainPay: Int
    let military: Bool
    let totalHiring: Int
    let jobCodeList: String
    let bookmarked: Bool

    enum CodingKeys: String, CodingKey {
        case recruitID = "recruit_id"
        case companyName = "company_name"
        case companyProfileURL = "company_profile_url"
        case trainPay = "train_pay"
        case military
        case totalHiring = "total_hiring"
        case jobCodeList = "job_code_list"
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
                military: $0.military,
                totalHiring: $0.totalHiring,
                jobCodeList: $0.jobCodeList,
                bookmarked: $0.bookmarked
            )
        }
    }
}
