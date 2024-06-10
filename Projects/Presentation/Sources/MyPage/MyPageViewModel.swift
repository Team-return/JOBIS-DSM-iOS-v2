import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MyPageViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchWritableReviewListUseCase: FetchWritableReviewListUseCase
    private let logoutUseCase: LogoutUseCase

    init(
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase,
        changeProfileImageUseCase: ChangeProfileImageUseCase,
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchWritableReviewListUseCase: FetchWritableReviewListUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchWritableReviewListUseCase = fetchWritableReviewListUseCase
        self.logoutUseCase = logoutUseCase
    }

    private let disposeBag = DisposeBag()

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let reviewNavigate: PublishRelay<Int>
        let helpSectionDidTap: Observable<IndexPath>
        let changePasswordSectionDidTap: Observable<IndexPath>
        let logoutPublisher: PublishRelay<Void>
        let withdrawalPublisher: PublishRelay<Void>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let writableReviewList: BehaviorRelay<[WritableReviewCompanyEntity]>
    }

    public func transform(_ input: Input) -> Output {
        let studentInfo = PublishRelay<StudentInfoEntity>()
        let writableReviewList = BehaviorRelay<[WritableReviewCompanyEntity]>(value: [])
        let changedImageURL = PublishRelay<String>()

        input.viewAppear.asObservable()
            .flatMap { self.fetchStudentInfoUseCase.execute() }
            .bind(to: studentInfo)
            .disposed(by: disposeBag)

        input.viewAppear.asObservable()
            .flatMap { self.fetchWritableReviewListUseCase.execute() }
            .bind(to: writableReviewList)
            .disposed(by: disposeBag)

        input.reviewNavigate.asObservable()
            .map { _ in MyPageStep.writableReviewIsRequired }
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

        input.logoutPublisher
            .do(onNext: { _ in
                self.logoutUseCase.execute()
            })
            .map { _ in MyPageStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.withdrawalPublisher
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
