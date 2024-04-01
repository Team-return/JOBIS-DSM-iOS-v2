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

    init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchApplicationUseCase: FetchApplicationUseCase,
        fetchBannerListUseCase: FetchBannerListUseCase
    ) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchApplicationUseCase = fetchApplicationUseCase
        self.fetchBannerListUseCase = fetchBannerListUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let navigateToAlarmButtonDidTap: Signal<Void>
        let navigateToCompanyButtonDidTap: Signal<Void>
        let rejectButtonDidTap: PublishRelay<ApplicationEntity>
        let reApplyButtonDidTap: PublishRelay<ApplicationEntity>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let applicationList: PublishRelay<[ApplicationEntity]>
        let bannerList: BehaviorRelay<[FetchBannerEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let applicationList = PublishRelay<[ApplicationEntity]>()
        let bannerList = BehaviorRelay<[FetchBannerEntity]>(value: [])

        input.viewAppear.asObservable()
            .flatMap { [self] in
                fetchStudentInfoUseCase.execute()
            }
            .do(onNext: {
                UserDefaults.standard.set($0.studentGcn.prefix(1), forKey: "user_grade")
            })
            .bind(to: studentInfo)
            .disposed(by: disposeBag)

        input.navigateToAlarmButtonDidTap.asObservable()
            .map { _ in
                HomeStep.alarmIsRequired
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.navigateToCompanyButtonDidTap.asObservable()
            .map { _ in HomeStep.companyIsRequired }
            .bind(to: steps)
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

        return Output(
            studentInfo: studentInfo,
            applicationList: applicationList,
            bannerList: bannerList
        )
    }
}
