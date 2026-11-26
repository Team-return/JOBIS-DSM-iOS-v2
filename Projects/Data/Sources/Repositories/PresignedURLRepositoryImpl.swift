import RxSwift
import Domain
import Foundation

struct PresignedURLRepositoryImpl: PresignedURLRepository {
    private let remotePresignedURLDataSource: any RemotePresignedURLDataSource

    init(remotePresignedURLDataSource: any RemotePresignedURLDataSource) {
        self.remotePresignedURLDataSource = remotePresignedURLDataSource
    }

    func uploadImageToS3(presignedURL: String, data: Data, contentType: String) -> Completable {
        remotePresignedURLDataSource.uploadImageToS3(
            presignedURL: presignedURL,
            data: data,
            contentType: contentType
        )
    }
}
