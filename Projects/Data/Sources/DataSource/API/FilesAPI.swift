import Moya
import Foundation
import Domain
import AppNetwork

enum FilesAPI {
    case uploadFiles(data: [Data], fileName: String)
}

extension FilesAPI: JobisAPI {
    typealias ErrorType = JobisError

    var domain: JobisDomain {
        .files
    }

    var urlPath: String {
        return ""
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case let .uploadFiles(data, fileName):
            var multipartData: [MultipartFormData] {
                data.map {
                    MultipartFormData(
                        provider: .data($0),
                        name: "file",
                        fileName: fileName
                    )
                }
            }

            return .uploadCompositeMultipart(
                multipartData,
                urlParameters: ["type": "EXTENSION_FILE"]
            )
        }
    }

    var jwtTokenType: JwtTokenType {
        .none
    }

    var errorMap: [Int: ErrorType]? {
        return [:]
    }
}
