import RxSwift
import Foundation
import Domain

protocol FilesRemote {
    func uploadFiles(data: [Data], fileName: String) -> Single<[String]>
}

final class FilesRemoteImpl: BaseRemote<FilesAPI>, FilesRemote {
    func uploadFiles(data: [Data], fileName: String) -> Single<[String]> {
        request(.uploadFiles(data: data, fileName: fileName))
            .map(UploadFilesResponseDTO.self)
            .map(\.urls)
    }
}
