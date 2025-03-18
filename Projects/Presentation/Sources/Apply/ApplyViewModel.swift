import Core
import Foundation
import Domain
import RxFlow
import RxSwift
import RxCocoa

public enum ApplyType {
    case apply
    case reApply
}

public final class ApplyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var recruitmentId: Int?
    public var applicationId: Int?
    public var companyName: String?
    public var companyImageURL: String?
    public var applyType: ApplyType = .apply
    private let disposeBag = DisposeBag()
    private let documents = BehaviorRelay<[AttachmentsRequestQuery]>(value: [])
    private var updateUrls: [AttachmentsRequestQuery] = []
    private let urls = BehaviorRelay<[AttachmentsRequestQuery]>(value: [])
    private let applyCompanyUseCase: ApplyCompanyUseCase
    private let reApplyCompanyUseCase: ReApplyCompanyUseCase

    public init(
        applyCompanyUseCase: ApplyCompanyUseCase,
        reApplyCompanyUseCase: ReApplyCompanyUseCase
    ) {
        self.applyCompanyUseCase = applyCompanyUseCase
        self.reApplyCompanyUseCase = reApplyCompanyUseCase
    }

    public struct Input {
        let documentAddButtonDidTap: PublishRelay<AttachmentsRequestQuery>
        let urlsAddButtonDidTap: Signal<Void>
        let urlsWillChanged: PublishRelay<(Int, String)>
        let applyButtonDidTap: Signal<Void>
        let removeUrlsButtonDidTap: Signal<Int>
        let removeDocsButtonDidTap: Signal<Int>
    }
    public struct Output {
        let documents: BehaviorRelay<[AttachmentsRequestQuery]>
        let urls: BehaviorRelay<[AttachmentsRequestQuery]>
        let applyButtonEnabled: BehaviorRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let applyButtonEnabled = BehaviorRelay<Bool>(value: false)
        input.documentAddButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.documents.accept(self.documents.value + [$0])
            })
            .disposed(by: disposeBag)

        input.urlsAddButtonDidTap.asObservable()
            .bind { [weak self] in
                self?.updateUrls.append(.init(url: "", type: .url))
                self?.urls.accept(self?.updateUrls ?? [])
            }
            .disposed(by: disposeBag)

        input.urlsWillChanged.asObservable()
            .bind(onNext: {
                self.updateUrls[$0.0] = .init(url: $0.1, type: .url)
            })
            .disposed(by: disposeBag)

        input.applyButtonDidTap.asObservable()
            .map { self.documents.value + self.updateUrls }
            .flatMap { [self] in
                return applyType == .apply ?
                applyCompanyUseCase.execute(
                    id: recruitmentId!,
                    req: .init(attachments: $0)
                )
                .andThen(Single.just(ApplyStep.popToRecruitmentDetail))
                .catchAndReturn(ApplyStep.errorToast(message: "합격된 회사가 존재합니다"))
                : reApplyCompanyUseCase.execute(
                    id: applicationId!,
                    req: .init(attachments: $0)
                ).andThen(Single.just(ApplyStep.popToRecruitmentDetail))
                .catchAndReturn(ApplyStep.errorToast(message: "합격된 회사가 존재합니다"))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.removeUrlsButtonDidTap.asObservable()
            .bind { index in
                self.updateUrls.remove(at: index)
                self.urls.accept(self.updateUrls)
            }
            .disposed(by: disposeBag)

        input.removeDocsButtonDidTap.asObservable()
            .bind { index in
                var olderList = self.documents.value
                olderList.remove(at: index)
                self.documents.accept(olderList)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(documents, urls)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: applyButtonEnabled)
            .disposed(by: disposeBag)

        return Output(documents: documents, urls: urls, applyButtonEnabled: applyButtonEnabled)
    }
}
