import Core
import Foundation
import Domain
import RxFlow
import RxSwift
import RxCocoa

public final class ApplyViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let documents = BehaviorRelay<[AttachmentsEntity]>(value: [])
    private var updateUrls: [AttachmentsEntity] = []
    private let urls = BehaviorRelay<[AttachmentsEntity]>(value: [])
    public init() {}

    public struct Input {
        let documentAddButtonDidTap: PublishRelay<AttachmentsEntity>
        let urlsAddButtonDidTap: Signal<Void>
        let urlsWillChanged: PublishRelay<(Int, String)>
        let applyButtonDidTap: Signal<Void>
        let removeButtonDidTap: Signal<Int>
    }
    public struct Output {
        let documents: BehaviorRelay<[AttachmentsEntity]>
        let urls: BehaviorRelay<[AttachmentsEntity]>
    }

    public func transform(_ input: Input) -> Output {
        input.documentAddButtonDidTap.asObservable()
            .subscribe(onNext: {
                self.documents.accept(self.documents.value + [$0])
            })
            .disposed(by: disposeBag)

        input.urlsAddButtonDidTap.asObservable()
            .bind { [weak self] in
                self?.urls.accept((self?.urls.value ?? []) + [.init(url: "", type: .url)])
                self?.updateUrls += [.init(url: "", type: .url)]
            }
            .disposed(by: disposeBag)

        input.urlsWillChanged.asObservable()
            .bind(onNext: {
                self.updateUrls[$0.0] = .init(url: $0.1, type: .url)
            })
            .disposed(by: disposeBag)

        input.applyButtonDidTap.asObservable()
            .bind {
                print(self.updateUrls)
            }
            .disposed(by: disposeBag)

        input.removeButtonDidTap.asObservable()
            .bind { index in
                self.updateUrls = self.updateUrls.enumerated()
                    .filter { $0.offset != index }
                    .map { $0.element }
            }
            .disposed(by: disposeBag)

        return Output(documents: documents, urls: urls)
    }
}
