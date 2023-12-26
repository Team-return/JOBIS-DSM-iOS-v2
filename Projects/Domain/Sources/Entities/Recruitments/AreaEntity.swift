import Foundation

public struct AreaEntity: Equatable, Hashable {
    public let areaID: Int
    public let job: String
    public let tech: [String]
    public let hiring: Int
    public let majorTask: String
    public let preferentialTreatment: String?

    public init(
        areaID: Int,
        job: String,
        tech: [String],
        hiring: Int,
        majorTask: String,
        preferentialTreatment: String?
    ) {
        self.areaID = areaID
        self.job = job
        self.tech = tech
        self.hiring = hiring
        self.majorTask = majorTask
        self.preferentialTreatment = preferentialTreatment
    }
}
