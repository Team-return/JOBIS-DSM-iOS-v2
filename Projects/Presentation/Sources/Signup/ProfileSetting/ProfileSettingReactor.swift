import Core
import UIKit
import Domain
import RxFlow
import RxSwift
import RxCocoa
import Utility
import ReactorKit

public final class ProfileSettingReactor: BaseReactor, Reactor {
    public enum Action {
        case selectProfileImage(UploadFileModel)
        case laterButtonDidTap
        case nextButtonDidTap
    }

    public enum Mutation {
        case setProfileImage(UploadFileModel?)
        case navigateToPrivacy(name: String, gcn: Int, email: String, password: String, isMan: Bool, profileImageURL: String?)
    }

    public struct State {
        public let name: String
        public let gcn: Int
        public let email: String
        public let password: String
        public let isMan: Bool
        public var profileImage: UploadFileModel?
        public var isNextButtonEnabled: Bool = false
    }

    public var initialState: State
    public let steps = PublishRelay<Step>()
    private let fetchPresignedURLUseCase: FetchPresignedURLUseCase
    private let uploadImageToS3UseCase: UploadImageToS3UseCase

    public init(
        name: String,
        gcn: Int,
        email: String,
        password: String,
        isMan: Bool,
        fetchPresignedURLUseCase: FetchPresignedURLUseCase,
        uploadImageToS3UseCase: UploadImageToS3UseCase
    ) {
        self.fetchPresignedURLUseCase = fetchPresignedURLUseCase
        self.uploadImageToS3UseCase = uploadImageToS3UseCase
        self.initialState = State(name: name, gcn: gcn, email: email, password: password, isMan: isMan)
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectProfileImage(model):
            return .just(.setProfileImage(model))

        case .laterButtonDidTap:
            let name = currentState.name
            let gcn = currentState.gcn
            let email = currentState.email
            let password = currentState.password
            let isMan = currentState.isMan

            return .just(.navigateToPrivacy(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                profileImageURL: nil
            ))

        case .nextButtonDidTap:
            let name = currentState.name
            let gcn = currentState.gcn
            let email = currentState.email
            let password = currentState.password
            let isMan = currentState.isMan
            let file = currentState.profileImage

            guard let file = file, file.file != Data() else {
                return .just(.navigateToPrivacy(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password,
                    isMan: isMan,
                    profileImageURL: nil
                ))
            }

            return fetchPresignedURLUseCase.execute(
                req: .init(files: [.init(fileName: file.fileName)])
            )
            .asObservable()
            .flatMap { presignedURLs -> Observable<String?> in
                guard let presignedURL = presignedURLs.first else {
                    return .just(nil)
                }

                return self.uploadImageToS3UseCase.execute(
                    presignedURL: presignedURL.presignedUrl,
                    data: file.file
                )
                .andThen(Observable.just(presignedURL.filePath as String?))
                .catchAndReturn(nil)
            }
            .map { profileImageURL in
                Mutation.navigateToPrivacy(
                    name: name,
                    gcn: gcn,
                    email: email,
                    password: password,
                    isMan: isMan,
                    profileImageURL: profileImageURL
                )
            }
            .catchAndReturn(.navigateToPrivacy(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                profileImageURL: nil
            ))
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setProfileImage(model):
            newState.profileImage = model
            newState.isNextButtonEnabled = model != nil

        case let .navigateToPrivacy(name, gcn, email, password, isMan, profileImageURL):
            steps.accept(ProfileSettingStep.privacyIsRequired(
                name: name,
                gcn: gcn,
                email: email,
                password: password,
                isMan: isMan,
                profileImageURL: profileImageURL
            ))
        }

        return newState
    }
}
