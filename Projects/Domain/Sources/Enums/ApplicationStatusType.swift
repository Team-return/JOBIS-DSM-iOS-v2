import Foundation

public enum ApplicationStatusType: String, Codable {
    case requested = "REQUESTED"
    case approved = "APPROVED"
    case failed = "FAILED"
    case pass = "PASS"
    case rejected = "REJECTED"
    case fieldTrain = "FIELD_TRAIN"
    case send = "SEND"
    case acceptance = "ACCEPTANCE"

    public func localizedString() -> String {
        switch self {
        case .requested:
            return "요청됨"

        case .approved:
            return "승인됨"

        case .failed:
            return "탈락"

        case .pass:
            return "합격"

        case .rejected:
            return "반려"

        case .fieldTrain:
            return "현장 실습"

        case .send:
            return "전송"

        case .acceptance:
            return "근로계약"
        }
    }
}
