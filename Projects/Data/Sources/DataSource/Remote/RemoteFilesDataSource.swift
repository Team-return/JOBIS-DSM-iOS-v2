import RxSwift
import Foundation
import Domain

protocol RemoteFilesDataSource {
    func uploadFiles(data: [Data], fileName: String) -> Single<[String]>
}

final class RemoteFilesDataSourceImpl: RemoteBaseDataSource<FilesAPI>, RemoteFilesDataSource {
    func uploadFiles(data: [Data], fileName: String) -> Single<[String]> {
        request(.uploadFiles(data: data, fileName: fileName))
            .map(UploadFilesResponseDTO.self)
            .map(\.urls)
    }
}
