import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class ScheduleManagementReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State

    public init(
    ) {
        self.initialState = .init()
    }

    public enum Action {}

    public enum Mutation {}

    public struct State {}
}
