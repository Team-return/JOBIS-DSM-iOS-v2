import Foundation
import Domain

public struct AreaResponseDTO: Decodable {
    public let id: Int
    public let job: [String]
    public let tech: [String]
    public let hiring: Int
    public let majorTask: String
    public let preferentialTreatment: String?

    public init(
        id: Int,
        job: [String],
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

    enum CodingKeys: String, CodingKey {
        case id, job, tech, hiring
        case majorTask = "major_task"
        case preferentialTreatment = "preferential_treatment"
    }
}

public extension AreaResponseDTO {
    func toDomain() -> AreaEntity {
        AreaEntity(
            id: String(id),
            job: job.joined(separator: ", "),
            tech: tech,
            hiring: hiring,
            majorTask: majorTask,
            preferentialTreatment: preferentialTreatment
        )
    }
}
