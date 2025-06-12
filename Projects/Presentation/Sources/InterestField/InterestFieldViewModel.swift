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
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let studentNameRelay = BehaviorRelay<String>(value: "")

    public init(
        fetchCodeListUseCase: FetchCodeListUseCase,
        changeInterestsUseCase: ChangeInterestsUseCase,
        fetchStudentInfoUseCase: FetchStudentInfoUseCase
    ) {
        self.fetchCodeListUseCase = fetchCodeListUseCase
        self.changeInterestsUseCase = changeInterestsUseCase
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        fetchStudentInfo()
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let selectButtonDidTap: Signal<Void>
        let selectedInterests: Observable<[CodeEntity]>
    }

    public struct Output {
        let availableInterests: BehaviorRelay<[CodeEntity]>
        let selectedInterests: Driver<[CodeEntity]>
        let studentName: Driver<String>
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

                let codeIDs = interests.map { $0.code }

                self.changeInterestsUseCase.execute(codeIDs: codeIDs)
                    .subscribe(
                        onCompleted: { [weak self] in
                            self?.steps.accept(InterestFieldStep.interestFieldCheckIsRequired)
                        },
                        onError: { _ in
                        }
                    )
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(
            availableInterests: availableInterests,
            selectedInterests: selectedInterests,
            studentName: studentNameRelay.asDriver()
        )
    }

    private func fetchStudentInfo() {
        fetchStudentInfoUseCase.execute()
            .subscribe(
                onSuccess: { [weak self] studentInfo in
                    self?.studentNameRelay.accept(studentInfo.studentName)
                },
                onFailure: { _ in
                }
            )
            .disposed(by: disposeBag)
    }
}
