import Foundation

public enum CompanySortType: String, CaseIterable {
    case take = "TAKE"
    case workersCountDesc = "WORKERS_COUNT_DESC"
    case workersCountAsc = "WORKERS_COUNT_ASC"
    case foundedAtDesc = "FOUNDED_AT_DESC"
    case foundedAtAsc = "FOUNDED_AT_ASC"

    public init?(localizedString: String) {
        guard let type = Self.allCases.first(where: { $0.localizedString() == localizedString }) else {
            return nil
        }
        self = type
    }

    public func localizedString() -> String {
        switch self {
        case .take:
            return "매출"

        case .workersCountDesc:
            return "직원 ↓"

        case .workersCountAsc:
            return "직원 ↑"

        case .foundedAtDesc:
            return "설립일 ↓"

        case .foundedAtAsc:
            return "설립일 ↑"
        }
    }
}
