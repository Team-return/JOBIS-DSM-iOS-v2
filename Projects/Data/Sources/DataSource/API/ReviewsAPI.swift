import Moya
import Domain
import AppNetwork

enum ReviewsAPI {
    case postReview(PostReviewRequestQuery)
    case reviewListPageCount
}

extension ReviewsAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .reviews
    }

    var urlPath: String {
        switch self {
        case .postReview:
            return ""
        case .reviewListPageCount:
            return "/count"
        }
    }

    var method: Method {
        switch self {
        case .reviewListPageCount:
            return .get
        case .postReview:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .postReview(req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }

    var jwtTokenType: JwtTokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    var errorMap: [Int: ErrorType]? {
        switch self {
        default:
            return [:]
        }
    }
}
