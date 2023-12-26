import Foundation
import Domain

struct BugListResponseDTO: Decodable {
    let bugReports: [BugReportResponseDTO]

    enum CodingKeys: String, CodingKey {
        case bugReports = "bug_reports"
    }
}

struct BugReportResponseDTO: Decodable {
    let bugID: Int
    let title: String
    let developmentArea: DevelopmentType
    let createdAt: String

    public enum CodingKeys: String, CodingKey {
        case bugID = "id"
        case title
        case developmentArea = "development_area"
        case createdAt = "created_at"
    }
}

extension BugListResponseDTO {
    func toDomain() -> [BugReportEntity] {
        bugReports.map {
            BugReportEntity(
                bugID: $0.bugID,
                title: $0.title,
                developmentArea: $0.developmentArea,
                createdAt: $0.createdAt
            )
        }
    }
}
