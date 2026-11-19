import RxSwift
import Foundation
import AppNetwork
import Domain

protocol RemotePresignedURLDataSource {
    func uploadImageToS3(presignedURL: String, data: Data, contentType: String) -> Completable
}

final class RemotePresignedURLDataSourceImpl: RemoteBaseDataSource<PresignedURLAPI>,
                                              RemotePresignedURLDataSource {
    func uploadImageToS3(presignedURL: String, data: Data, contentType: String) -> Completable {
        request(.uploadImageToS3(presignedURL: presignedURL, data: data, contentType: contentType))
            .asCompletable()
    }
}
