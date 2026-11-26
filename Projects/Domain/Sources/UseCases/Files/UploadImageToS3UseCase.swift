import RxSwift
import Foundation

public struct UploadImageToS3UseCase {
    public init(presignedURLRepository: PresignedURLRepository) {
        self.presignedURLRepository = presignedURLRepository
    }

    private let presignedURLRepository: PresignedURLRepository

    public func execute(
        presignedURL: String,
        data: Data,
        contentType: String = "image/jpg"
    ) -> Completable {
        presignedURLRepository.uploadImageToS3(
            presignedURL: presignedURL,
            data: data,
            contentType: contentType
        )
    }
}
