import Foundation

public enum LocationType: String, Encodable, Decodable, CaseIterable {
    case daejeon = "DAEJEON"
    case seoul = "SEOUL"
    case gyeonggi = "GYEONGGI"
    case other = "OTHER"

    public var koreanName: String {
        switch self {
        case .daejeon: return "대전"
        case .seoul: return "서울"
        case .gyeonggi: return "경기"
        case .other: return "기타"
        }
    }
}
