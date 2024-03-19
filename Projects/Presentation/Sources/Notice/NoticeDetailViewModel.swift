import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NoticeDetailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    public var noticeID: Int?
    private let fetchNoticeDetailUseCase: FetchNoticeDetailUseCase
    private let disposeBag = DisposeBag()

    init(
        fetchNoticeDetailUseCase: FetchNoticeDetailUseCase
    ) {
        self.fetchNoticeDetailUseCase = fetchNoticeDetailUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
    }

    public struct Output {
        let noticeDetailInfo: PublishRelay<NoticeDetailEntity>
    }

    public func transform(_ input: Input) -> Output {
        let noticeDetailInfo = PublishRelay<NoticeDetailEntity>()

                input.viewAppear.asObservable()
                    .flatMap { _ in
                        self.fetchNoticeDetailUseCase.execute(id: self.noticeID ?? 0)
                    }
                    .bind(to: noticeDetailInfo)
                    .disposed(by: disposeBag)
        return Output(noticeDetailInfo: noticeDetailInfo)
    }
}
