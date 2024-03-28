import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class AlarmViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    private let fetchNotificationListUseCase: FetchNotificationListUseCase
    private let readNotificationUseCase: ReadNotificationUseCase

    init(
        fetchNotificationListUseCase: FetchNotificationListUseCase,
        readNotificationUseCase: ReadNotificationUseCase
    ) {
        self.readNotificationUseCase = readNotificationUseCase
        self.fetchNotificationListUseCase = fetchNotificationListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let readNotification: Observable<(NotificationEntity, IndexPath)>
    }

    public struct Output {
        let notificationList: BehaviorRelay<[NotificationEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let notificationList = BehaviorRelay<[NotificationEntity]>(value: [])

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchNotificationListUseCase.execute()
            }
            .bind(to: notificationList)
            .disposed(by: disposeBag)

        input.readNotification.asObservable()
            .do(onNext: {
                var oldList = notificationList.value
                oldList[$0.1.row] = .init(
                    notificationID: $0.0.notificationID,
                    title: $0.0.title,
                    content: $0.0.content,
                    topic: $0.0.topic,
                    detailID: $0.0.detailID,
                    createdAt: $0.0.createdAt,
                    new: false
                )
                notificationList.accept(oldList)
            })
            .flatMap {
                self.readNotificationUseCase.execute(id: $0.0.notificationID)
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(notificationList: notificationList)
    }
}
