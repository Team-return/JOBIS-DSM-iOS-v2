import Foundation
import RxSwift
import RxCocoa
import Domain
@testable import Presentation

final class MockUsersRepository: UsersRepository {
    var shouldSucceed: Bool = true
    var errorToThrow: Error?

    func signin(req: SigninRequestQuery) -> Single<AuthorityType> {
        if shouldSucceed {
            return .just(.student)
        } else if let error = errorToThrow {
            return .error(error)
        } else {
            return .just(.student)
        }
    }

    func logout() {}

    func deleteDeviceToken() -> Completable {
        return .empty()
    }
}

func createTestSigninReactor() -> SigninReactor {
    let mockRepository = MockUsersRepository()
    let signinUseCase = SigninUseCase(usersRepository: mockRepository)
    return SigninReactor(signinUseCase: signinUseCase)
}
