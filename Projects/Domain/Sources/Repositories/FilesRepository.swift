import RxSwift
import Foundation

public protocol FilesRepository {
    func fetchPresignedURL(req: UploadFilesRequestDTO) -> Single<[PresignedURLEntity]>
}
