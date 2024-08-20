import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class NotificationSettingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let subscribeNotificationUseCase: SubscribeNotificationUseCase
    private let subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase

    init(
        subscribeNotificationUseCase: SubscribeNotificationUseCase,
        subscribeAllNotificationUseCase: SubscribeAllNotificationUseCase
    ) {
        self.subscribeNotificationUseCase = subscribeNotificationUseCase
        self.subscribeAllNotificationUseCase = subscribeAllNotificationUseCase
    }

    public struct Input {

    }

    public struct Output {

    }

    public func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
