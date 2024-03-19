import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NoticeViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let fetchNoticeListUseCase: FetchNoticeListUseCase
    private let disposeBag = DisposeBag()

    init(
        fetchNoticeListUseCase: FetchNoticeListUseCase
    ) {
        self.fetchNoticeListUseCase = fetchNoticeListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let noticeTableViewCellDidTap: PublishRelay<Int>
    }

    public struct Output {
        let noticeListInfo: PublishRelay<[NoticeEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let noticeListInfo = PublishRelay<[NoticeEntity]>()

        input.viewAppear.asObservable()
            .flatMap { _ in
                self.fetchNoticeListUseCase.execute()
            }
            .bind(to: noticeListInfo)
            .disposed(by: disposeBag)

        input.noticeTableViewCellDidTap.asObservable()
            .map { id in
                NoticeStep.noticeDetailIsRequired(id: id)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            noticeListInfo: noticeListInfo
        )
    }
}
