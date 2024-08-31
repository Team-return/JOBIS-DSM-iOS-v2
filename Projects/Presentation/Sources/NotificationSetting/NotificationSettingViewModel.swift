import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain
import FirebaseMessaging

public final class NotificationSettingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let subscribeNotificationUseCase: SubscribeNotificationUseCase
    private let subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase
    private let unsubscribeNotificationUseCase: UnsubscribeNotificationUseCase
    private let unsubscribeAllNotificationUseCase: UnsubscribeAllNotificationUseCase

    init(
        subscribeNotificationUseCase: SubscribeNotificationUseCase,
        subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase,
        unsubscribeNotificationUseCase: UnsubscribeNotificationUseCase,
        unsubscribeAllNotificationUseCase: UnsubscribeAllNotificationUseCase
    ) {
        self.subscribeNotificationUseCase = subscribeNotificationUseCase
        self.subscribeAllNotificationUseCase = subscribeAllNotificationUseCase
        self.unsubscribeNotificationUseCase = unsubscribeNotificationUseCase
        self.unsubscribeAllNotificationUseCase = unsubscribeAllNotificationUseCase
    }

    public struct Input {
        let allSwitchButtonIsTrue: PublishRelay<Bool>
        let noticeSwitchButtonIsTrue: PublishRelay<Bool>
        let applicationSwitchButtonIsTrue: PublishRelay<Bool>
        let recruitmentSwitchButtonIsTrue: PublishRelay<Bool>
    }

    public struct Output { }

    public func transform(_ input: Input) -> Output {
        input.allSwitchButtonIsTrue.asObservable()
            .flatMap {
                if $0 {
                    return self.subscribeAllNotificationUseCase.execute(token: Messaging.messaging().fcmToken ?? "")
                } else {
                    return self.unsubscribeAllNotificationUseCase.execute(token: Messaging.messaging().fcmToken ?? "")
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.noticeSwitchButtonIsTrue.asObservable()
            .flatMap {
                if $0 {
                    return self.subscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .notice
                    )
                } else {
                    return self.unsubscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .notice
                    )
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.applicationSwitchButtonIsTrue.asObservable()
            .flatMap {
                if $0 {
                    return self.subscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .application
                    )
                } else {
                    return self.unsubscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .application
                    )
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.recruitmentSwitchButtonIsTrue.asObservable()
            .flatMap {
                if $0 {
                    return self.subscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .recruitment
                    )
                } else {
                    return self.unsubscribeNotificationUseCase.execute(
                        token: Messaging.messaging().fcmToken ?? "",
                        notificationType: .recruitment
                    )
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output()
    }
}
