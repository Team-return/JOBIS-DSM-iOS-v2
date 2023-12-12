import Kingfisher
import UIKit

public extension UIImageView {
    func setJobisImage(urlString: String, placeholder: Placeholder? = nil) {
        let baseURL = URL(string: "https://jobis-store.s3.ap-northeast-2.amazonaws.com")!
        var imageUrl: URL? {
            if urlString.contains(baseURL.description) {
                return URL(string: urlString)
            } else {
                return baseURL.appendingPathComponent(urlString)
            }
        }

        kf.setImage(
            with: imageUrl,
            placeholder: placeholder
        )
    }

    func resize(_ targetSize: CGSize) {
        self.image = image?.resize(targetSize)
    }
}
