import Foundation
import Domain

protocol LocalRecruitmentFilterDataSource {
    func saveFilter(_ filter: RecruitmentFilterEntity)
    func fetchFilter() -> RecruitmentFilterEntity
}

public struct LocalRecruitmentFilterDataSourceImpl: LocalRecruitmentFilterDataSource {
    private let userDefaults = UserDefaults.standard
    private let key = "RECRUITMENT_FILTER"

    public init() {}

    public func saveFilter(_ filter: RecruitmentFilterEntity) {
        guard let data = try? JSONEncoder().encode(RecruitmentFilterDTO(entity: filter)) else { return }
        userDefaults.set(data, forKey: key)
    }

    public func fetchFilter() -> RecruitmentFilterEntity {
        guard let data = userDefaults.data(forKey: key),
              let dto = try? JSONDecoder().decode(RecruitmentFilterDTO.self, from: data)
        else { return .empty }
        return dto.toDomain()
    }
}
