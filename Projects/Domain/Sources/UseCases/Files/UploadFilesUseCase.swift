import RxSwift
import Foundation

public struct UploadFilesUseCase {
    public init(filesRepository: FilesRepository) {
        self.filesRepository = filesRepository
    }

    private let filesRepository: FilesRepository

    public func execute(data: [Data], fileName: String) -> Single<[String]> {
        return filesRepository.uploadFiles(data: data, fileName: fileName)
    }
}
