import Core
import UIKit
import Domain
import RxFlow
import RxSwift
import RxCocoa

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
        let nextButtonDidTap: Signal<Void>
    }

    public struct Output {}

    public func transform(_ input: Input) -> Output {
        // TODO: 리팩토링 해야함
        input.nextButtonDidTap.asObservable()
            .withLatestFrom(input.profileImage)
            .bind { model in
                guard let file = model?.file else {
                    self.steps.accept(
                        ProfileSettingStep.privacyIsRequired(
                            name: input.name,
                            gcn: input.gcn,
                            email: input.email,
                            password: input.password,
                            isMan: input.isMan,
                            profileImageURL: nil
                        )
                    )
                    return
                }

                return self.fetchPresignedURLUseCase.execute(
                    req: .init(files: [.init(fileName: "\(input.name)_profileImage.png")])
                )
                .asObservable()
                .bind { url in
                    guard let presigneURL = url.first?.presignedUrl else { return }
                    self.uploadImageToS3UseCase.execute(presignedURL: presigneURL, data: file)
                        .andThen(
                            Single.just(
                                ProfileSettingStep.privacyIsRequired(
                                    name: input.name,
                                    gcn: input.gcn,
                                    email: input.email,
                                    password: input.password,
                                    isMan: input.isMan,
                                    profileImageURL: presigneURL
                                )
                            )
                        )
                        .asObservable()
                        .bind(to: self.steps)
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
        return Output()
    }
}
