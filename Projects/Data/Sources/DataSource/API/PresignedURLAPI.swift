import Moya
import Foundation
import AppNetwork
import Domain

public enum PresignedURLAPI {
    case uploadImageToS3(presignedURL: String, data: Data)
}

extension PresignedURLAPI: JobisAPI {
    public typealias ErrorType = JobisError

    public var domain: JobisDomain {
        .presignedURL
    }

    public var urlPath: String {
        ""
    }

    public var baseURL: URL {
        switch self {
        case let .uploadImageToS3(presignedURL, _):
            return URL(string: presignedURL)!
        }
    }

    public var path: String {
        return ""
    }

    public var method: Moya.Method {
        return .put
    }

    public var task: Moya.Task {
        switch self {
        case let .uploadImageToS3(_, data):
            return .requestData(data)
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "image/jpg"]
    }

    public var jwtTokenType: JwtTokenType {
        .none
    }

    public var errorMap: [Int: JobisError]? {
        [:]
    }
}
