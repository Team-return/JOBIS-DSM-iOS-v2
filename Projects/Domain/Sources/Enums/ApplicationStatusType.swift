import Foundation

public enum ApplicationStatusType: String, Codable {
    case requested = "REQUESTED"
    case approved = "APPROVED"
    case send = "SEND"
    case failed = "FAILED"
    case pass = "PASS"
    case rejected = "REJECTED"
    case fieldTrain = "FIELD_TRAIN"
    case acceptance = "ACCEPTANCE"
    case docFailed = "DOC_FAILED"
    case processing = "PROCESSING"

    public func localizedString() -> String {
        switch self {
        case .requested:
            return "승인 요청"

        case .approved:
            return "승인"

        case .failed:
            return "탈락"

        case .pass:
            return "합격"

        case .rejected:
            return "반려"

        case .fieldTrain:
            return "현장실습"

        case .send:
            return "지원 중"

        case .acceptance:
            return "근로계약"

        case .docFailed:
            return "서류 탈락"

        case .processing:
            return "진행중"
        }
    }
}
