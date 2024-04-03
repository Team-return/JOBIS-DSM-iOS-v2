import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RecruitmentFilterViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCodeListUseCase: FetchCodeListUseCase

    init(fetchCodeListUseCase: FetchCodeListUseCase) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
    }

    public struct Output {
        let jobList: BehaviorRelay<[CodeEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let jobList = BehaviorRelay<[CodeEntity]>(value: [])
        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
            }
            .bind(to: jobList)
            .disposed(by: disposeBag)

        return Output(jobList: jobList)
    }
}
