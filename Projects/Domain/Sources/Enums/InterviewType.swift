import Foundation

// swiftlint: disable identifier_name
public enum InterviewType: String, Decodable {
    case cultureInterview = "CULTURE_INTERVIEW"
    case document = "DOCUMENT"
    case task = "TASK"
    case liveCoding = "LIVE_CODING"
    case techInterview = "TECH_INTERVIEW"
    case finalInterview = "FINAL_INTERVIEW"
    case personality = "PERSONALITY"
    case ai = "AI"
    case codingTest = "CODING_TEST"

    public func localizedString() -> String {
        switch self {
        case .cultureInterview:
            return "컬처 면접"

        case .document:
            return "서류전형"

        case .task:
            return "과제 제출"

        case .liveCoding:
            return "라이브코딩"

        case .techInterview:
            return "기술면접"

        case .finalInterview:
            return "최종면접"

        case .personality:
            return "인적성 테스트"

        case .ai:
            return "AI 면접"

        case .codingTest:
            return "코딩테스트"
        }
    }
}
// swiftlint: enable identifier_name
