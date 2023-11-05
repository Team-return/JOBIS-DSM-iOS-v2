import Foundation
import Domain

struct AreaResponseDTO: Decodable {
    let id: Int
    let job: [String]
    let tech: [String]
    let hiring: Int
    let majorTask: String
    let preferentialTreatment: String?

    enum CodingKeys: String, CodingKey {
        case id, job, tech, hiring
        case majorTask = "major_task"
        case preferentialTreatment = "preferential_treatment"
    }
}

extension AreaResponseDTO {
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
