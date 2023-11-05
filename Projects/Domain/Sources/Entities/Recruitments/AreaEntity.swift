import Foundation

public struct AreaEntity: Equatable, Hashable {
    public let id: String
    public let job: String
    public let tech: [String]
    public let hiring: Int
    public let majorTask: String
    public let preferentialTreatment: String?

    public init(
        id: String,
        job: String,
        tech: [String],
        hiring: Int,
        majorTask: String,
        preferentialTreatment: String?
    ) {
        self.id = id
        self.job = job
        self.tech = tech
        self.hiring = hiring
        self.majorTask = majorTask
        self.preferentialTreatment = preferentialTreatment
    }
}
