import RxSwift
import Foundation

public protocol PresignedURLRepository {
    func uploadImageToS3(presignedURL: String, data: Data) -> Completable
}
