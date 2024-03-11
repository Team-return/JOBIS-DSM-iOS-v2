import Domain
import Foundation
import Moya
import AppNetwork

public enum FilesAPI {
    case fetchPresignedURL(req: UploadFilesRequestDTO)
}

extension FilesAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .files
    }

    public var urlPath: String {
        return "/pre-signed"
    }

    public var method: Moya.Method {
        return .post
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchPresignedURL(req):
            return .requestJSONEncodable(req)
        }
    }

    public var jwtTokenType: JwtTokenType {
        .none
    }

    public var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
