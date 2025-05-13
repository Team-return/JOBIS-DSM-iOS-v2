import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class InterestFieldViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchInterestsUseCase: FetchInterestsUseCase
    private let changeInterestsUseCase: ChangeInterestsUseCase
    private let isLoading = PublishRelay<Bool>()

    init(
        fetchInterestsUseCase: FetchInterestsUseCase,
        changeInterestsUseCase: ChangeInterestsUseCase
    ) {
        self.fetchInterestsUseCase = fetchInterestsUseCase
        self.changeInterestsUseCase = changeInterestsUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let selectButtonDidTap: Signal<Void>
        let selectedInterests: Observable<[InterestsEntity]>
    }

    public struct Output {
        let availableInterests: BehaviorRelay<[InterestsEntity]>
        let userSavedInterests: PublishRelay<[InterestsEntity]>
        let selectedInterests: Driver<[InterestsEntity]>
        let isLoading: Driver<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let fixedInterests = createFixedInterestsList()
        let availableInterests = BehaviorRelay<[InterestsEntity]>(value: fixedInterests)
        let userSavedInterests = PublishRelay<[InterestsEntity]>()

        input.viewAppear.asObservable()
            .flatMap { self.fetchInterestsUseCase.execute() }
            .bind(to: userSavedInterests)
            .disposed(by: disposeBag)

        let selectedInterests = input.selectedInterests
            .asDriver(onErrorJustReturn: [])

        input.selectButtonDidTap
            .withLatestFrom(selectedInterests)
            .emit(onNext: { [weak self] interests in
                guard let self = self else { return }
                print("선택된 관심분야: \(interests.map { $0.keyword })")

                self.isLoading.accept(true)
                self.changeInterestsUseCase.execute(interests: interests)
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
            userSavedInterests: userSavedInterests,
            selectedInterests: selectedInterests,
            isLoading: isLoading.asDriver(onErrorJustReturn: false)
        )
    }

    private func createFixedInterestsList() -> [InterestsEntity] {
        let interestData: [(keyword: String, code: Int)] = [
            ("백엔드", 1),
            ("프론트엔드", 2),
            ("풀스택", 3),
            ("Android", 4),
            ("iOS", 5),
            ("임베디드", 6),
            ("보안", 7)
        ]

        var fixedInterests: [InterestsEntity] = []
        for (index, data) in interestData.enumerated() {
            let interest = InterestsEntity(
                studentName: "",
                interestID: index + 1,
                studentID: 0,
                code: data.code,
                keyword: data.keyword
            )
            fixedInterests.append(interest)
        }
        return fixedInterests
    }
}
