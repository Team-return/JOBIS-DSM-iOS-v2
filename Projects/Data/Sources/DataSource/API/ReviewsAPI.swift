import Moya
import Domain
import AppNetwork

enum ReviewsAPI {
    case fetchReviewDetail(id: Int)
    case fetchReviewList(id: Int)
    case postReview(PostReviewRequestQuery)
}

extension ReviewsAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .reviews
    }

    var urlPath: String {
        switch self {
        case let .fetchReviewDetail(id):
            return "/details/\(id)"

        case let .fetchReviewList(id):
            return "/\(id)"

        case .postReview:
            return ""
        }
    }

    var method: Method {
        switch self {
        case .fetchReviewList, .fetchReviewDetail:
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
