import RxSwift
import Domain
import Foundation

struct FilesRepositoryImpl: FilesRepository {
    private let remoteFilesDataSource: any RemoteFilesDataSource

    init(remoteFilesDataSource: any RemoteFilesDataSource) {
        self.remoteFilesDataSource = remoteFilesDataSource
    }

    func uploadFiles(data: [Data], fileName: String) -> Single<[String]> {
        remoteFilesDataSource.uploadFiles(data: data, fileName: fileName)
    }
}
