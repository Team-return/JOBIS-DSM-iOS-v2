import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ReviewCompleteViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase

    public init(fetchStudentInfoUseCase: FetchStudentInfoUseCase) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
    }

    public struct Input {
        let viewDidAppear: PublishRelay<Void>
    }

    public struct Output {
        let userName: Observable<String>
    }

    public func transform(_ input: Input) -> Output {
        let userName = input.viewDidAppear
            .flatMapLatest { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                return self.fetchStudentInfoUseCase.execute()
                    .asObservable()
                    .map { $0.studentName }
                    .catch { _ in .just("") }
            }
            .share(replay: 1)

        input.viewDidAppear
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .map { WritableReviewStep.popToMyPage }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(userName: userName)
    }
}
