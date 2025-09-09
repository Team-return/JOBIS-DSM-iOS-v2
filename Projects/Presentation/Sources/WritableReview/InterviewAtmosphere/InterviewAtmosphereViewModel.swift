import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core

public final class InterviewAtmosphereViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    public struct Input {
        let viewWillAppear: Observable<Void>
        let atmosphereText: Observable<String>
        let nextButtonDidTap: Observable<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let characterCount: Observable<Int>
    }

    private let atmosphereTextRelay = BehaviorRelay<String>(value: "")
    
    public func transform(_ input: Input) -> Output {
        input.atmosphereText
            .bind(to: atmosphereTextRelay)
            .disposed(by: disposeBag)
        
        let isNextButtonEnabled = input.atmosphereText
            .map { text in
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                return !trimmedText.isEmpty && trimmedText.count <= 500
            }
        
        let characterCount = input.atmosphereText
            .map { $0.count }
        
        input.nextButtonDidTap
            .withLatestFrom(atmosphereTextRelay)
            .subscribe(onNext: { [weak self] atmosphereText in
                self?.steps.accept(AddReviewStep.interviewAtmosphereIsRequired)
            })
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            characterCount: characterCount
        )
    }

    public func getAtmosphereText() -> String {
        return atmosphereTextRelay.value
    }
}
