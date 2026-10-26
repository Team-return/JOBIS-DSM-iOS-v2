import Foundation

public enum UnapplicableReasonType: String {
    case alreadyApplied = "ALREADY_APPLIED"
    case notRecruiting = "NOT_RECRUITING"
    case hasActiveApplication = "HAS_ACTIVE_APPLICATION"
    case gradeNotEligible = "GRADE_NOT_ELIGIBLE"
    case unknown

    public func localizedString() -> String {
        switch self {
        case .alreadyApplied:
            return "이미 지원한 기업이에요"

        case .notRecruiting:
            return "모집 중이 아니에요"

        case .hasActiveApplication:
            return "이미 다른 기업에 지원했어요"

        case .gradeNotEligible:
            return "지원 가능한 학년이 아니에요"

        case .unknown:
            return "지원할 수 없어요"
        }
    }
}
