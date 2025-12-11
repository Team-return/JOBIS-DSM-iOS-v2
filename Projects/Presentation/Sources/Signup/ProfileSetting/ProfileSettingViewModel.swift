import Core
import UIKit
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility

public final class ProfileSettingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    private let disposeBag = DisposeBag()
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase

    init(
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase
    ) {
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
    }

    public struct Input {
        let name: String
        let gcn: Int
        let email: String
        let password: String
        let isMan: Bool
        let profileImage: BehaviorRelay<UploadFileModel?>
        let laterButtonDidTap: Signal<Void>
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        let profileImageWithTap = input.nextButtonDidTap.asObservable()
            .withLatestFrom(input.profileImage)
            .avoidDuplication
            .filter { $0?.file != nil }

        let presignedURLWithData = profileImageWithTap
            .flatMap { file -> Observable<(PresignedURLEntity?, Data?)> in
                self.fetchPresignedURLUseCase.execute(
                    req: .init(files: [.init(fileName: file?.fileName ?? "")])
                )
                .asObservable()
                .map { ($0.first, file?.file) }
            }

        let uploadedStep = presignedURLWithData
            .flatMap { (url, data) -> Single<ProfileSettingStep> in
                self.uploadImageToS3UseCase.execute(
                    presignedURL: url?.presignedUrl ?? "",
                    data: data ?? Data()
                )
                .andThen(
                    Single.just(ProfileSettingStep.privacyIsRequired(
                        name: input.name,
                        gcn: input.gcn,
                        email: input.email,
                        password: input.password,
                        isMan: input.isMan,
                        profileImageURL: url?.filePath ?? ""
                    ))
                )
            }

        let fallbackStep = ProfileSettingStep.privacyIsRequired(
            name: input.name,
            gcn: input.gcn,
            email: input.email,
            password: input.password,
            isMan: input.isMan,
            profileImageURL: nil
        )

        uploadedStep
            .asObservable()
            .catchAndReturn(fallbackStep)
            .map { $0 as Step }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.laterButtonDidTap.asObservable()
            .map { _ -> Step in fallbackStep }
            .bind(to: self.steps)
            .disposed(by: self.disposeBag)

        return Output()
    }
}
