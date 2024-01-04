import Kingfisher
import UIKit

public extension UIImageView {
    func setJobisImage(urlString: String, placeholder: Placeholder? = nil) {
        var baseURL: URL {
            URL(
                string: Bundle.main.object(forInfoDictionaryKey: "S3_BASE_URL") as? String ?? ""
            ) ?? URL(string: "https://www.google.com")!
        }
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
}
