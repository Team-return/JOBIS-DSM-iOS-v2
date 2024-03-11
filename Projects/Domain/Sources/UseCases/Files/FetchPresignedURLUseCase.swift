import RxSwift
import Foundation

public struct FetchPresignedURLUseCase {
    public init(filesRepository: FilesRepository) {
        self.filesRepository = filesRepository
    }

    private let filesRepository: FilesRepository

    public func execute(req: UploadFilesRequestDTO) -> Single<[PresignedURLEntity]> {
        filesRepository.fetchPresignedURL(req: req)
    }
}
