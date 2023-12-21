import RxSwift
import RxCocoa

public class SignupViewController<T: BaseViewModel>: BaseViewController<T> {
    let nextPublishRelay = PublishRelay<Void>()

    func nextSignupStep() {
        self.nextPublishRelay.accept(())
    }
}
