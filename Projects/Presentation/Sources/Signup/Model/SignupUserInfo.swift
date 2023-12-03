import Foundation
import Domain

enum SignupError: Error {
    case existEmptyValue
}

class SignupUserInfo {
    static let shared = SignupUserInfo()

    var email, password: String?
    var grade: Int?
    var name: String?
    var gender: GenderType? = .man
    var classRoom, number: Int?

    private init() { }
}

extension SignupUserInfo {
    static func toQuery() throws -> SignupRequestQuery {
        guard let email = shared.email,
              let password = shared.password,
              let grade = shared.grade,
              let name = shared.name,
              let gender = shared.gender,
              let classRoom = shared.classRoom,
              let number = shared.number else { throw SignupError.existEmptyValue }
        return SignupRequestQuery(
            email: email.dsmEmail(),
            password: password,
            grade: grade,
            name: name,
            gender: gender,
            classRoom: classRoom,
            number: number
        )
    }

    static func removeInfo() {
        shared.email = nil
        shared.password = nil
        shared.grade = nil
        shared.name = nil
        shared.gender = nil
        shared.classRoom = nil
        shared.number = nil
    }
}
