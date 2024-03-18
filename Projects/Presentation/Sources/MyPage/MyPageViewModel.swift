import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MyPageViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchWritableReviewListUseCase: FetchWritableReviewListUseCase
    private let logoutUseCase: LogoutUseCase

    init(
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchWritableReviewListUseCase: FetchWritableReviewListUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchWritableReviewListUseCase = fetchWritableReviewListUseCase
        self.logoutUseCase = logoutUseCase
    }

    private let disposeBag = DisposeBag()

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let reviewNavigate: Observable<Int>
        let helpSectionDidTap: Observable<IndexPath>
        let changePasswordSectionDidTap: Observable<IndexPath>
        let logoutSectionDidTap: Observable<IndexPath>
        let withdrawalSectionDidTap: Observable<IndexPath>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let writableReviewList: BehaviorRelay<[WritableReviewCompanyEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let writableReviewList = BehaviorRelay<[WritableReviewCompanyEntity]>(value: [])

        input.viewAppear.asObservable()
            .flatMap { self.fetchStudentInfoUseCase.execute() }
            .bind(to: studentInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { self.fetchWritableReviewListUseCase.execute() }
            .bind(to: writableReviewList)
            .disposed(by: disposeBag)

        input.reviewNavigate.asObservable()
            .map { _ in MyPageStep.writeReviewIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.helpSectionDidTap.asObservable()
            .map { _ in MyPageStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.changePasswordSectionDidTap.asObservable()
            .map { _ in MyPageStep.confirmIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.logoutSectionDidTap
            .do(onNext: { _ in
                self.logoutUseCase.execute()
            })
            .map { _ in MyPageStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.withdrawalSectionDidTap
            .do(onNext: { _ in
                self.logoutUseCase.execute()
            })
            .map { _ in MyPageStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            studentInfo: studentInfo,
            writableReviewList: writableReviewList
        )
    }
}
