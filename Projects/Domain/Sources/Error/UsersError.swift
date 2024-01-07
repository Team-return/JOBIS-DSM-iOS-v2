import Foundation

public enum UsersError: Error {
    case notFoundPassword
    case notFoundEmail
    case internalServerError
    case badRequest
}

extension UsersError: LocalizedError {
    public var errorDescription: String? {
        switch self {

        case .notFoundPassword:
            return "비밀번호가 옳지 않아요"

        case .notFoundEmail:
            return "아이디를 찾지 못했어요"

        case .internalServerError:
            return "인터넷 환경을 확인해주세요."

        case .badRequest:
            return "비밀번호 형식에 맞지 않아요."
        }
    }
}
