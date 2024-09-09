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
    private let fetchSubscribeStateUseCase: FetchSubscribeStateUseCase

    init(
        subscribeNotificationUseCase: SubscribeNotificationUseCase,
        subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase,
        fetchSubscribeStateUseCase: FetchSubscribeStateUseCase
    ) {
        self.subscribeNotificationUseCase = subscribeNotificationUseCase
        self.subscribeAllNotificationUseCase = subscribeAllNotificationUseCase
        self.fetchSubscribeStateUseCase = fetchSubscribeStateUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let allSwitchButtonDidTap: ControlProperty<Bool>
        let noticeSwitchButtonDidTap: ControlProperty<Bool>
        let applicationSwitchButtonDidTap: ControlProperty<Bool>
        let recruitmentSwitchButtonDidTap: ControlProperty<Bool>
    }

    public struct Output {
        let subscribeNoticeState: PublishRelay<SubscribeStateEntity>
        let subscribeApplicationState: PublishRelay<SubscribeStateEntity>
        let subscribeRecruitmentState: PublishRelay<SubscribeStateEntity>
        let allSubscribeState: PublishRelay<Bool>
    }

    public func transform(_ input: Input) -> Output {
        let subscribeStateList = PublishRelay<[SubscribeStateEntity]>()
        let subscribeNoticeState = PublishRelay<SubscribeStateEntity>()
        let subscribeApplicationState = PublishRelay<SubscribeStateEntity>()
        let subscribeRecruitmentState = PublishRelay<SubscribeStateEntity>()

        let noticeState = BehaviorRelay<Bool>(value: false)
        let applicationState = BehaviorRelay<Bool>(value: false)
        let recruitmentState = BehaviorRelay<Bool>(value: false)
        let allSubscribeState = PublishRelay<Bool>()

        input.viewAppear.asObservable()
            .flatMap {
                self.fetchSubscribeStateUseCase.execute()
            }
            .bind(to: subscribeStateList)
            .disposed(by: disposeBag)

        subscribeStateList.asObservable()
            .subscribe(onNext: {
                for state in $0 {
                    if state.topic == .notice {
                        subscribeNoticeState.accept(state)
                        noticeState.accept(state.isSubscribed)
                    } else if state.topic == .application {
                        subscribeApplicationState.accept(state)
                        applicationState.accept(state.isSubscribed)
                    } else if state.topic == .recruitment {
                        subscribeRecruitmentState.accept(state)
                        recruitmentState.accept(state.isSubscribed)
                    }

                    if noticeState.value || applicationState.value || recruitmentState.value {
                        allSubscribeState.accept(true)
                    } else {
                        allSubscribeState.accept(false)
                    }
                }
            })
            .disposed(by: disposeBag)

        input.allSwitchButtonDidTap.asObservable()
            .skip(1)
            .flatMap { _ in
                self.subscribeAllNotificationUseCase.execute()
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.noticeSwitchButtonDidTap.asObservable()
            .skip(1)
            .flatMap { _ in
                self.subscribeNotificationUseCase.execute(
                    token: Messaging.messaging().fcmToken ?? "",
                    notificationType: .notice
                )
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.applicationSwitchButtonDidTap.asObservable()
            .skip(1)
            .flatMap { _ in
                self.subscribeNotificationUseCase.execute(
                    token: Messaging.messaging().fcmToken ?? "",
                    notificationType: .application
                )
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.recruitmentSwitchButtonDidTap.asObservable()
            .skip(1)
            .flatMap { _ in
                self.subscribeNotificationUseCase.execute(
                    token: Messaging.messaging().fcmToken ?? "",
                    notificationType: .recruitment
                )
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            subscribeNoticeState: subscribeNoticeState,
            subscribeApplicationState: subscribeApplicationState,
            subscribeRecruitmentState: subscribeRecruitmentState,
            allSubscribeState: allSubscribeState
        )
    }
}
