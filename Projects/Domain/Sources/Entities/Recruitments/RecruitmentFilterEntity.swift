public struct RecruitmentFilterEntity: Equatable {
    public let jobCode: String
    public let techCode: [String]?
    public let years: [String]?
    public let region: String?
    public let status: String?

    public init(
        jobCode: String = "",
        techCode: [String]? = nil,
        years: [String]? = nil,
        region: String? = nil,
        status: String? = nil
    ) {
        self.jobCode = jobCode
        self.techCode = techCode
        self.years = years
        self.region = region
        self.status = status
    }

    public static let empty = RecruitmentFilterEntity()
}
