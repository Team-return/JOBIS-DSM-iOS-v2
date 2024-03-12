import Moya
import Domain
import AppNetwork

enum BannersAPI {
    case fetchBannerList
}

extension BannersAPI: JobisAPI {
    typealias ErrorType = UsersError

    var domain: JobisDomain {
        .banners
    }

    var urlPath: String {
        return ""
    }

    var method: Method {
        return .get
    }

    var task: Task {
        return .requestPlain
    }

    var jwtTokenType: JwtTokenType {
        return .accessToken
    }

    var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
