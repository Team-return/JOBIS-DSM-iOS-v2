import Foundation

public enum InterviewFormat: String, Encodable, Decodable, CaseIterable {
    case individual = "INDIVIDUAL"
    case group = "GROUP"
    case other = "OTHER"

    public var koreanName: String {
        switch self {
        case .individual: return "개인 면접"
        case .group: return "그룹 면접"
        case .other: return "기타"
        }
    }
}
