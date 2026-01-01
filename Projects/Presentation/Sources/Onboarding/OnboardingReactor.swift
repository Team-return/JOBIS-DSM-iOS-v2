import Core
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility
import ReactorKit

public final class OnboardingReactor: BaseReactor {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let disposeBag = DisposeBag()

    private let reissueTokenUseCase: ReissueTokenUseCase
    private let fetchServerStatusUseCase: FetchServerStatusUseCase

    public init(
        reissueTokenUseCase: ReissueTokenUseCase,
        fetchServerStatusUseCase: FetchServerStatusUseCase
    ) {
        self.reissueTokenUseCase = reissueTokenUseCase
        self.fetchServerStatusUseCase = fetchServerStatusUseCase
        self.initialState = State()
    }

    public enum Action {
        case viewDidAppear
        case signinButtonDidTap
        case signupButtonDidTap
    }

    public enum Mutation {
        case setAnimate
        case setShowNavigationButton
        case setServerStatusError
    }

    public struct State {
        var shouldAnimate: Bool = false
        var shouldShowNavigationButton: Bool = false
        var shouldShowServerStatusAlert: Bool = false
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidAppear:
            return .merge(
                .just(.setAnimate),
                checkTokenAndServerStatus()
            )

        case .signinButtonDidTap:
            steps.accept(OnboardingStep.signinIsRequired)
            return .empty()

        case .signupButtonDidTap:
            steps.accept(OnboardingStep.signupIsRequired)
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setAnimate:
            newState.shouldAnimate = true

        case .setShowNavigationButton:
            newState.shouldShowNavigationButton = true

        case .setServerStatusError:
            newState.shouldShowServerStatusAlert = true
        }

        return newState
    }

    private func checkTokenAndServerStatus() -> Observable<Mutation> {
        let tokenCheck = reissueTokenUseCase.execute()
            .asObservable()
            .do(onNext: { [weak self] _ in
                self?.steps.accept(OnboardingStep.tabsIsRequired)
            })
            .flatMap { _ in Observable<Mutation>.empty() }
            .catch { _ in .just(.setShowNavigationButton) }

        let serverStatusCheck = fetchServerStatusUseCase.execute()
            .asObservable()
            .flatMap { _ in Observable<Mutation>.empty() }
            .catch { _ in .just(.setServerStatusError) }

        return .merge(tokenCheck, serverStatusCheck)
    }
}
