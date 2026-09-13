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
            region: region,
            status: status
        )
    }
}
