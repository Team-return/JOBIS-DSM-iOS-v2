import Nuke
import UIKit
import ImageIO

public extension UIImageView {
    func setJobisImage(urlString: String, placeholder: UIImage? = nil) {
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

        guard let imageUrl = imageUrl else { return }

        if let placeholder = placeholder {
            self.image = placeholder
        }

        let request = ImageRequest(url: imageUrl)

        ImagePipeline.shared.loadImage(with: request) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    UIView.transition(
                        with: self,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.image = response.image
                        }
                    )
                }
            case .failure:
                break
            }
        }
    }
}
