import Core
import Foundation
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ApplyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var recruitmentId: Int?
    public var companyName: String?
    public var companyImageURL: String?
    private let disposeBag = DisposeBag()
    private let documents = BehaviorRelay<[AttachmentsRequestQuery]>(value: [])
    private var updateUrls: [AttachmentsRequestQuery] = []
    private let urls = BehaviorRelay<[AttachmentsRequestQuery]>(value: [])
    private let applyCompanyUseCase: ApplyCompanyUseCase
    public init(applyCompanyUseCase: ApplyCompanyUseCase) {
        self.applyCompanyUseCase = applyCompanyUseCase
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
                return applyCompanyUseCase.execute(
                    id: recruitmentId ?? 0,
                    req: .init(attachments: $0)
                )
                .andThen(Single.just(ApplyStep.popToRecruitmentDetail))
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
            .map { !($0.0.isEmpty && $0.1.isEmpty) }
            .bind(to: applyButtonEnabled)
            .disposed(by: disposeBag)

        return Output(documents: documents, urls: urls, applyButtonEnabled: applyButtonEnabled)
    }
}
