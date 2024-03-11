import RxSwift
import Foundation
import AppNetwork
import Domain

protocol RemotePresignedURLDataSource {
    func uploadImageToS3(presignedURL: String, data: Data) -> Completable
}

final class RemotePresignedURLDataSourceImpl: RemoteBaseDataSource<PresignedURLAPI>,
                                              RemotePresignedURLDataSource {
    func uploadImageToS3(presignedURL: String, data: Data) -> Completable {
        request(.uploadImageToS3(presignedURL: presignedURL, data: data))
            .asCompletable()
    }
}
