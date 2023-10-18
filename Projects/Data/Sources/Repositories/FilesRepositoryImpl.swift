import RxSwift
import Domain
import Foundation

final class FilesRepositoryImpl: FilesRepository {
    private let filesRemote: any FilesRemote

    init(filesRemote: any FilesRemote) {
        self.filesRemote = filesRemote
    }

    func uploadFiles(data: [Data], fileName: String) -> Single<[String]> {
        filesRemote.uploadFiles(data: data, fileName: fileName)
    }
}
