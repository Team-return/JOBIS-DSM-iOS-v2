import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public final class MyPageViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase
    private let changeProfileImageUseCase: ChangeProfileImageUseCase
    private let fetchStudentInfoUseCase: FetchStudentInfoUseCase
    private let fetchWritableReviewListUseCase: FetchWritableReviewListUseCase
    private let logoutUseCase: LogoutUseCase
    private let deleteDeviceTokenUseCase: DeleteDeviceTokenUseCase

    init(
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase,
        changeProfileImageUseCase: ChangeProfileImageUseCase,
        fetchStudentInfoUseCase: FetchStudentInfoUseCase,
        fetchWritableReviewListUseCase: FetchWritableReviewListUseCase,
        logoutUseCase: LogoutUseCase,
        deleteDeviceTokenUseCase: DeleteDeviceTokenUseCase
    ) {
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
        self.changeProfileImageUseCase = changeProfileImageUseCase
        self.fetchStudentInfoUseCase = fetchStudentInfoUseCase
        self.fetchWritableReviewListUseCase = fetchWritableReviewListUseCase
        self.logoutUseCase = logoutUseCase
        self.deleteDeviceTokenUseCase = deleteDeviceTokenUseCase
    }

    public struct Input {
        let viewAppear: PublishRelay<Void>
        let reviewNavigate: PublishRelay<Int>
        let selectedImage: PublishRelay<UploadFileModel>
        let notificationSettingSectionDidTap: Observable<IndexPath>
        let helpSectionDidTap: Observable<IndexPath>
        let bugReportSectionDidTap: Observable<IndexPath>
        //        let bugReportListSectionDidTap: Observable<IndexPath>
        let interestFieldDidTap: Observable<IndexPath>
        let changePasswordSectionDidTap: Observable<IndexPath>
        let logoutPublisher: PublishRelay<Void>
        let withdrawalPublisher: PublishRelay<Void>
        let changedImageURL: PublishRelay<String>
    }

    public struct Output {
        let studentInfo: PublishRelay<StudentInfoEntity>
        let writableReviewList: BehaviorRelay<[WritableReviewCompanyEntity]>
        let changedImageURL: PublishRelay<String>
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
            .map { MyPageStep.writableReviewIsRequired($0) }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.selectedImage
            .flatMapLatest { [weak self] file -> Observable<String?> in
                guard let self = self else { return .empty() }

                return self.fetchPresignedURLUseCase.execute(
                    req: .init(files: [.init(fileName: file.fileName)])
                )
                .asObservable()
                .flatMap { presignedURLs -> Observable<String?> in
                    guard let url = presignedURLs.first else { return .empty() }

                    return Observable.zip(
                        self.uploadImageToS3UseCase.execute(
                            presignedURL: url.presignedUrl,
                            data: file.file
                        )
                        .asObservable(),
                        self.changeProfileImageUseCase.execute(url: url.filePath)
                            .asObservable()
                    )
                    .map { _ in "" }
                }
            }
            .map { _ in "" }
            .bind(to: changedImageURL)
            .disposed(by: disposeBag)

        input.notificationSettingSectionDidTap.asObservable()
            .map { _ in MyPageStep.notificationSettingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.helpSectionDidTap.asObservable()
            .map { _ in MyPageStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.interestFieldDidTap.asObservable()
            .map { _ in MyPageStep.interestFieldIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.changePasswordSectionDidTap.asObservable()
            .map { _ in MyPageStep.confirmIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.logoutPublisher
            .do(onNext: { _ in
                self.logoutUseCase.execute()
                self.deleteDeviceTokenUseCase.execute()
            })
            .map { _ in MyPageStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.withdrawalPublisher
            .do(onNext: { _ in
                self.logoutUseCase.execute()
                self.deleteDeviceTokenUseCase.execute()
            })
            .map { _ in MyPageStep.tabsIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.bugReportSectionDidTap.asObservable()
            .map { _ in MyPageStep.bugReportIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        //        input.bugReportListSectionDidTap.asObservable()
        //            .map { _ in MyPageStep.bugReportListIsRequired }
        //            .bind(to: steps)
        //            .disposed(by: disposeBag)

        return Output(
            studentInfo: studentInfo,
            writableReviewList: writableReviewList,
            changedImageURL: changedImageURL
        )
    }
}
