import Domain

struct RecruitmentFilterDTO: Codable {
    let jobCode: String
    let techCode: [String]?
    let years: [String]?
    let region: String?
    let status: String?

    init(entity: RecruitmentFilterEntity) {
        self.jobCode = entity.jobCode
        self.techCode = entity.techCode
        self.years = entity.years
        self.region = entity.region
        self.status = entity.status
    }
}

extension RecruitmentFilterDTO {
    func toDomain() -> RecruitmentFilterEntity {
        RecruitmentFilterEntity(
            jobCode: jobCode,
            techCode: techCode,
            years: years,
            // 이전 버전에서 저장된 지역 '기타'(OTHER)는 서버 값(OTHERS)으로 변환
            region: region == "OTHER" ? "OTHERS" : region,
            status: status
        )
    }
}
