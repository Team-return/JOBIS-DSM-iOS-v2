import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class RejectReasonViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var applicationID: Int?
    public var recruitmentID: Int?
    public var companyName: String?
    public var companyImageUrl: String?
    private let disposeBag = DisposeBag()
    private let fetchRejectionReasonUseCase: FetchRejectionReasonUseCase

    init(fetchRejectionReasonUseCase: FetchRejectionReasonUseCase) {
        self.fetchRejectionReasonUseCase = fetchRejectionReasonUseCase
    }

    public struct Input {
        let viewWillAppear: PublishRelay<Void>
        let reApplyButtonDidTap: Signal<Void>
    }

    public struct Output {
        let rejectReason: PublishRelay<String>
    }

    public func transform(_ input: Input) -> Output {
        let rejectReason = PublishRelay<String>()

        input.viewWillAppear.asObservable()
            .flatMap {
                self.fetchRejectionReasonUseCase.execute(id: self.applicationID!)
            }
            .bind(to: rejectReason)
            .disposed(by: disposeBag)

        input.reApplyButtonDidTap.asObservable()
            .map { _ in
                RejectReasonStep.reApplyIsRequired(
                    recruitmentID: self.recruitmentID!,
                    applicationID: self.applicationID!,
                    companyName: self.companyName!,
                    companyImageUrl: self.companyImageUrl!
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(rejectReason: rejectReason)
    }
}
