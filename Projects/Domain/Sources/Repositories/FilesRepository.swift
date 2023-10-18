import RxSwift
import Foundation

public protocol FilesRepository {
    func uploadFiles(data: [Data], fileName: String) -> Single<[String]>
}
