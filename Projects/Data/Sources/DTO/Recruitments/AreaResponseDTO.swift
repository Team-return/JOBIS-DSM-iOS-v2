import Foundation
import Domain

struct AreaResponseDTO: Decodable {
    let areaID: Int
    let job: [JobResponseDTO]
    let tech: [TechReponseDTO]
    let hiring: Int
    let majorTask: String
    let preferentialTreatment: String?

    enum CodingKeys: String, CodingKey {
        case areaID = "id"
        case job, tech, hiring
        case majorTask = "major_task"
        case preferentialTreatment = "preferential_treatment"
    }
}

extension AreaResponseDTO {
    func toDomain() -> AreaEntity {
        AreaEntity(
            areaID: areaID,
            job: job.map { $0.name }.joined(separator: ", "),
            tech: tech.map { $0.name },
            hiring: hiring,
            majorTask: majorTask,
            preferentialTreatment: preferentialTreatment
        )
    }
}
