import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class HomeViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchApplicationUseCase: FetchApplicationUseCase
    private let fetchBannerListUseCase: FetchBannerListUseCase
    private let fetchWinterInternUseCase: FetchWinterInternSeasonUseCase
    private let fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase

    private var touchedPopcatCount = 0

    init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchApplicationUseCase: FetchApplicationUseCase,
        fetchBannerListUseCase: FetchBannerListUseCase,
        fetchWinterInternUseCase: FetchWinterInternSeasonUseCase,
        fetchTotalPassStudentUseCase: FetchTotalPassStudentUseCase
    ) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchApplicationUseCase = fetchApplicationUseCase
        self.fetchBannerListUseCase = fetchBannerListUseCase
        self.fetchWinterInternUseCase = fetchWinterInternUseCase
        self.fetchTotalPassStudentUseCase = fetchTotalPassStudentUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let viewDisappear: PublishRelay<Void>
        let navigateToAlarmButtonDidTap: Signal<Void>
        let navigateToEasterEggDidTap: PublishRelay<Void>
        let navigateToCompanyButtonDidTap: Signal<Void>
        let navigateToWinterInternButtonDidTap: Signal<Void>
        let rejectButtonDidTap: PublishRelay<ApplicationEntity>
        let reApplyButtonDidTap: PublishRelay<ApplicationEntity>
        let applicationStatusTableViewDidTap: Observable<(Int, ApplicationStatusType)>
        let employStatusButtonDidTap: Signal<Void>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let applicationList: PublishRelay<[ApplicationEntity]>
        let bannerList: BehaviorRelay<[FetchBannerEntity]>
        let isWinterInternSeason: BehaviorRelay<Bool>
        let totalPassStudentInfo: BehaviorRelay<TotalPassStudentEntity>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let applicationList = PublishRelay<[ApplicationEntity]>()
        let bannerList = BehaviorRelay<[FetchBannerEntity]>(value: [])
        let isWinterInternSeason = BehaviorRelay<Bool>(value: true)
        let totalPassStudentInfo = BehaviorRelay<TotalPassStudentEntity>(value: TotalPassStudentEntity.init(
            totalStudentCount: 0,
            passedCount: 0,
            approvedCount: 0
        ))

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchStudentInfoUseCase.execute()
            }
            .do(onNext: {
                UserDefaults.standard.set($0.studentGcn.prefix(1), forKey: "user_grade")
            })
            .bind(to: studentInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .bind { _ in
                self.touchedPopcatCount = 0
            }
            .disposed(by: disposeBag)

        input.navigateToAlarmButtonDidTap.asObservable()
            .map { _ in
                HomeStep.alarmIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToEasterEggDidTap.asObservable()
            .do { _ in
                self.touchedPopcatCount += 1
            }
            .filter { _ in
                self.touchedPopcatCount >= 5
            }
            .map { _ in
                self.touchedPopcatCount = 0
                return HomeStep.easterEggIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToCompanyButtonDidTap.asObservable()
            .map { _ in HomeStep.companyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToWinterInternButtonDidTap.asObservable()
            .map { _ in HomeStep.winterInternIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                let currentYear = Calendar.current.component(.year, from: Date())
                return fetchTotalPassStudentUseCase.execute(year: currentYear)
            }
            .bind(to: totalPassStudentInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchBannerListUseCase.execute()
            }
            .bind(to: bannerList)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchApplicationUseCase.execute()
            }
            .bind(to: applicationList)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchWinterInternUseCase.execute()
            }
            .bind(to: isWinterInternSeason)
            .disposed(by: disposeBag)

        input.rejectButtonDidTap.asObservable()
            .map {
                HomeStep.rejectReasonIsRequired(
                    recruitmentID: $0.recruitmentID,
                    applicationID: $0.applicationID,
                    companyName: $0.company,
                    companyImageURL: $0.companyLogoUrl
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.reApplyButtonDidTap.asObservable()
            .map {
                HomeStep.reApplyIsRequired(
                    recruitmentID: $0.recruitmentID,
                    applicationID: $0.applicationID,
                    companyName: $0.company,
                    companyImageURL: $0.companyLogoUrl
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.applicationStatusTableViewDidTap.asObservable()
            .map { id, status in
                if status == .pass || status == .fieldTrain {
                    return HomeStep.recruitmentDetailIsRequired(id: id)
                } else {
                    return HomeStep.none
                }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.employStatusButtonDidTap.asObservable()
              .map { HomeStep.employStatusIsRequired }
              .bind(to: steps)
              .disposed(by: disposeBag)

        return Output(
            studentInfo: studentInfo,
            applicationList: applicationList,
            bannerList: bannerList,
            isWinterInternSeason: isWinterInternSeason,
            totalPassStudentInfo: totalPassStudentInfo
        )
    }
}
