import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterestFieldViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchCodeListUseCase: FetchCodeListUseCase
    private let changeInterestsUseCase: ChangeInterestsUseCase
    private let isLoading = PublishRelay<Bool>()

    init(
        fetchCodeListUseCase: FetchCodeListUseCase,
        changeInterestsUseCase: ChangeInterestsUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
        self.changeInterestsUseCase = changeInterestsUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let selectButtonDidTap: Signal<Void>
        let selectedInterests: Observable<[CodeEntity]>
    }

    public struct Output {
        let availableInterests: BehaviorRelay<[CodeEntity]>
        let selectedInterests: Driver<[CodeEntity]>
        let isLoading: Driver<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let availableInterests = BehaviorRelay<[CodeEntity]>(value: [])

        input.viewAppear.asObservable()
            .flatMap { [weak self] _ -> Single<[CodeEntity]> in
                guard let self = self else { return .just([]) }
                return self.fetchCodeListUseCase.execute(keyword: nil, type: .job, parentCode: nil)
            }
            .bind(to: availableInterests)
            .disposed(by: disposeBag)

        let selectedInterests = input.selectedInterests
            .asDriver(onErrorJustReturn: [])

        input.selectButtonDidTap
            .withLatestFrom(selectedInterests)
            .emit(onNext: { [weak self] interests in
                guard let self = self else { return }
                print("선택된 관심분야: \(interests.map { $0.keyword })")
                self.isLoading.accept(true)

                let interestsEntities = interests.map { codeEntity in
                    InterestsEntity(
                        studentName: "",
                        interestID: 0,
                        studentID: 0,
                        code: codeEntity.code,
                        keyword: codeEntity.keyword
                    )
                }

                self.changeInterestsUseCase.execute(interests: interestsEntities)
                    .subscribe(
                        onCompleted: { [weak self] in
                            self?.isLoading.accept(false)
                            self?.steps.accept(InterestFieldStep.interestFieldCheckIsRequired)
                        },
                        onError: { [weak self] error in
                            self?.isLoading.accept(false)
                            print("관심분야 업데이트 실패: \(error.localizedDescription)")
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(
            availableInterests: availableInterests,
            selectedInterests: selectedInterests,
            isLoading: isLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
