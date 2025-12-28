import Foundation
import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class HomeReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    public let initialState: State
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchApplicationUseCase: FetchApplicationUseCase
    private let fetchBannerListUseCase: FetchBannerListUseCase
    private let fetchWinterInternUseCase: FetchWinterInternSeasonUseCase
    private let fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase

    public init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchApplicationUseCase: FetchApplicationUseCase,
        fetchBannerListUseCase: FetchBannerListUseCase,
        fetchWinterInternUseCase: FetchWinterInternSeasonUseCase,
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    ) {
        self.initialState = .init()
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchApplicationUseCase = fetchApplicationUseCase
        self.fetchBannerListUseCase = fetchBannerListUseCase
        self.fetchWinterInternUseCase = fetchWinterInternUseCase
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
    }

    public enum Action {
        case viewWillAppear
        case viewWillDisappear
        case navigateToAlarmButtonDidTap
        case navigateToEasterEggDidTap
        case navigateToCompanyButtonDidTap
        case navigateToWinterInternButtonDidTap
        case rejectButtonDidTap(ApplicationEntity)
        case reApplyButtonDidTap(ApplicationEntity)
        case applicationStatusTableViewDidTap(recruitmentID: Int, status: ApplicationStatusType)
        case employStatusButtonDidTap
    }

    public enum Mutation {
        case setStudentInfo(StudentInfoEntity)
        case setApplicationList([ApplicationEntity])
        case setBannerList([FetchBannerEntity])
        case setWinterInternSeason(Bool)
        case setTotalPassStudentInfo(TotalPassStudentEntity)
        case incrementEasterEggCount
        case resetEasterEggCount
    }

    public struct State {
        var studentInfo: StudentInfoEntity?
        var applicationList: [ApplicationEntity] = []
        var bannerList: [FetchBannerEntity] = []
        var isWinterInternSeason: Bool = true
        var totalPassStudentInfo: TotalPassStudentEntity = TotalPassStudentEntity(
            totalStudentCount: 0,
            passedCount: 0,
            approvedCount: 0
        )
        var touchedPopcatCount: Int = 0
    }
}

extension HomeReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return .concat([
                .just(.resetEasterEggCount),
                fetchStudentInfoUseCase.execute()
                    .asObservable()
                    .do(onNext: {
                        UserDefaults.standard.set($0.studentGcn.prefix(1), forKey: "user_grade")
                    })
                    .flatMap { studentInfo -> Observable<Mutation> in
                        .just(.setStudentInfo(studentInfo))
                    },
                fetchApplicationUseCase.execute()
                    .asObservable()
                    .flatMap { applicationList -> Observable<Mutation> in
                        .just(.setApplicationList(applicationList))
                    },
                fetchBannerListUseCase.execute()
                    .asObservable()
                    .flatMap { bannerList -> Observable<Mutation> in
                        .just(.setBannerList(bannerList))
                    },
                fetchWinterInternUseCase.execute()
                    .asObservable()
                    .flatMap { isWinterIntern -> Observable<Mutation> in
                        .just(.setWinterInternSeason(isWinterIntern))
                    },
                fetchTotalPassStudentUseCase.execute(year: Calendar.current.component(.year, from: Date()))
                    .asObservable()
                    .flatMap { totalPassStudent -> Observable<Mutation> in
                        .just(.setTotalPassStudentInfo(totalPassStudent))
                    }
            ])

        case .viewWillDisappear:
            return .empty()

        case .navigateToAlarmButtonDidTap:
            steps.accept(HomeStep.alarmIsRequired)
            return .empty()

        case .navigateToEasterEggDidTap:
            let newCount = currentState.touchedPopcatCount + 1
            if newCount >= 5 {
                steps.accept(HomeStep.easterEggIsRequired)
                return .just(.resetEasterEggCount)
            }
            return .just(.incrementEasterEggCount)

        case .navigateToCompanyButtonDidTap:
            steps.accept(HomeStep.companyIsRequired)
            return .empty()

        case .navigateToWinterInternButtonDidTap:
            steps.accept(HomeStep.winterInternIsRequired)
            return .empty()

        case let .rejectButtonDidTap(application):
            steps.accept(HomeStep.rejectReasonIsRequired(
                recruitmentID: application.recruitmentID,
                applicationID: application.applicationID,
                companyName: application.company,
                companyImageURL: application.companyLogoUrl
            ))
            return .empty()

        case let .reApplyButtonDidTap(application):
            steps.accept(HomeStep.reApplyIsRequired(
                recruitmentID: application.recruitmentID,
                applicationID: application.applicationID,
                companyName: application.company,
                companyImageURL: application.companyLogoUrl
            ))
            return .empty()

        case let .applicationStatusTableViewDidTap(recruitmentID, status):
            if status == .pass || status == .fieldTrain {
                steps.accept(HomeStep.recruitmentDetailIsRequired(id: recruitmentID))
            }
            return .empty()

        case .employStatusButtonDidTap:
            steps.accept(HomeStep.employStatusIsRequired)
            return .empty()
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setStudentInfo(studentInfo):
            newState.studentInfo = studentInfo

        case let .setApplicationList(applicationList):
            newState.applicationList = applicationList

        case let .setBannerList(bannerList):
            newState.bannerList = bannerList

        case let .setWinterInternSeason(isWinterIntern):
            newState.isWinterInternSeason = isWinterIntern

        case let .setTotalPassStudentInfo(totalPassStudent):
            newState.totalPassStudentInfo = totalPassStudent

        case .incrementEasterEggCount:
            newState.touchedPopcatCount += 1

        case .resetEasterEggCount:
            newState.touchedPopcatCount = 0
        }
        return newState
    }
}
