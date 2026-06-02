import Foundation

public enum RecruitmentSortType: String, CaseIterable {
    case take = "TAKE"
    case workersCountDesc = "WORKERS_COUNT_DESC"
    case workersCountAsc = "WORKERS_COUNT_ASC"
    case deadlineDesc = "DEADLINE_DESC"
    case deadlineAsc = "DEADLINE_ASC"

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

        case .deadlineDesc:
            return "공고마감 ↓"

        case .deadlineAsc:
            return "공고마감 ↑"
        }
    }
}
