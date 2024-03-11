import RxSwift
import Domain
import Foundation

struct FilesRepositoryImpl: FilesRepository {
    private let remoteFilesDataSource: any RemoteFilesDataSource

    init(remoteFilesDataSource: any RemoteFilesDataSource) {
        self.remoteFilesDataSource = remoteFilesDataSource
    }

    func fetchPresignedURL(req: UploadFilesRequestDTO) -> Single<[PresignedURLEntity]> {
        remoteFilesDataSource.fetchPresignedURL(req: req)
    }
}
