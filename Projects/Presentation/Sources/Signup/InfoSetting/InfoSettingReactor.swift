import Core
import Moya
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain
import Utility
import ReactorKit

public final class InfoSettingReactor: BaseReactor, Reactor {
    public enum Action {
        case updateName(String)
        case updateGCN(String)
        case nextButtonDidTap
    }

    public enum Mutation {
        case setName(String)
        case setGCN(String)
        case setNameError(DescriptionType?)
        case setGCNError(DescriptionType?)
        case navigateToVerifyEmail(name: String, gcn: Int)
    }

    public struct State {
        public var name: String = ""
        public var gcn: String = ""
        public var nameErrorDescription: DescriptionType?
        public var gcnErrorDescription: DescriptionType?
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()
    private let studentExistsUseCase: StudentExistsUseCase

    public init(studentExistsUseCase: StudentExistsUseCase) {
        self.studentExistsUseCase = studentExistsUseCase
        self.initialState = State()
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateName(name):
            return .just(.setName(name))

        case let .updateGCN(gcn):
            return .just(.setGCN(gcn))

        case .nextButtonDidTap:
            let name = currentState.name
            let gcn = currentState.gcn

            // 입력값 검증
            if name.isEmpty {
                return .just(.setNameError(.error(description: "이름을 입력해주세요")))
            } else if gcn.isEmpty {
                return .just(.setGCNError(.error(description: "학번을 입력해주세요")))
            }

            // 에러 초기화 후 API 호출
            return .concat([
                .just(.setNameError(nil)),
                .just(.setGCNError(nil)),
                studentExistsUseCase.execute(gcn: gcn, name: name)
                    .andThen(Observable<Mutation>.empty())
                    .catch { [weak self] error in
                        if let appError = error as? ApplicationsError {
                            switch appError {
                            case .conflict:
                                return .just(.setGCNError(.error(description: "이미 가입 된 학번이에요.")))

                            case .badRequest:
                                return .just(.setGCNError(.error(description: "학번이나 이름을 확인해주세요.")))

                            case .internalServerError:
                                return .just(.setGCNError(.error(description: "서버 오류가 발생했어요.")))
                            }
                        }

                        // 에러가 아닌 경우 (학생이 존재하지 않는 경우 - 가입 가능)
                        guard let gcnInt = Int(gcn) else {
                            return .just(.setGCNError(.error(description: "올바른 학번을 입력해주세요.")))
                        }
                        return .just(.navigateToVerifyEmail(name: name, gcn: gcnInt))
                    }
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setName(name):
            newState.name = name

        case let .setGCN(gcn):
            newState.gcn = gcn

        case let .setNameError(error):
            newState.nameErrorDescription = error

        case let .setGCNError(error):
            newState.gcnErrorDescription = error

        case let .navigateToVerifyEmail(name, gcn):
            steps.accept(InfoSettingStep.verifyEmailIsRequired(name: name, gcn: gcn))
        }

        return newState
    }
}
