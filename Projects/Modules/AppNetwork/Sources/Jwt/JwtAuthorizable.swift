import Moya

public enum JwtTokenType: String {
    case accessToken = "Authorization"
    case refreshToken = "X-Refresh-Token"
    case none
}

public protocol JwtAuthorizable {
    var jwtTokenType: JwtTokenType { get }
}
