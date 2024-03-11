import RxSwift
import AppNetwork
import Domain

protocol RemoteFilesDataSource {
    func fetchPresignedURL(req: UploadFilesRequestDTO) -> Single<[PresignedURLEntity]>
}

final class RemoteFilesDataSourceImpl: RemoteBaseDataSource<FilesAPI>, RemoteFilesDataSource {
    func fetchPresignedURL(req: UploadFilesRequestDTO) -> Single<[PresignedURLEntity]> {
        request(.fetchPresignedURL(req: req))
            .map(FetchPresignedURLResponseDTO.self)
            .map { $0.toDomain() }
    }
}
