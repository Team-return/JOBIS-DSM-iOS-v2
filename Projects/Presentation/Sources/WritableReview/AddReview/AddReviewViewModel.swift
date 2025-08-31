import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class AddReviewViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCodeListUseCase: FetchCodeListUseCase
    public let question = BehaviorRelay<String>(value: "")
    public let answer = BehaviorRelay<String>(value: "")
    public let techCode = BehaviorRelay<String>(value: "")
    public var techCodeEntity = CodeEntity(code: 0, keyword: "")

    init(
        fetchCodeListUseCase: FetchCodeListUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let appendTechCode: PublishRelay<CodeEntity>
        let addReviewButtonDidTap: PublishRelay<Void>
        let searchButtonDidTap: PublishRelay<String>
    }

    public struct Output {
        let techList: BehaviorRelay<[CodeEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let techList = BehaviorRelay<[CodeEntity]>(value: [])

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: nil, type: .tech, parentCode: nil)
            }
            .bind(to: techList)
            .disposed(by: disposeBag)

        input.appendTechCode.asObservable()
            .filter { "\($0.code)" != "" }
            .bind {
                var value = self.techCode.value
                value.append("\($0)")
                self.techCodeEntity = $0
                self.techCode.accept(value)
            }
            .disposed(by: disposeBag)

        input.addReviewButtonDidTap.asObservable()
            .map {
                AddReviewStep.dismissToWritableReview
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.searchButtonDidTap.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(
                    keyword: $0,
                    type: .tech,
                    parentCode: ""
                )
            }
            .bind(to: techList)
            .disposed(by: disposeBag)

        return Output(
            techList: techList
        )
    }
}
