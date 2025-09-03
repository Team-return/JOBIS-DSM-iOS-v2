import Foundation

public enum LocationType: String, Encodable, Decodable {
    case daejeon = "DAEJEON"
    case seoul = "SEOUL"
    case gyeonggi = "GYEONGGI"
    case other = "OTHER"
}
