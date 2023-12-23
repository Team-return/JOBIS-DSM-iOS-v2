import UIKit
import Foundation

public extension UIImage {
    static func onboardingImage(_ icon: OnboardingImage) -> UIImage {
        icon.uiImage()
    }
}

public enum OnboardingImage {
    case teamReturnLogo

    func uiImage() -> UIImage {
        let dsImages = DesignSystemAsset.Images.self

        switch self {
        case .teamReturnLogo:
            return dsImages.teamReturnLogo.image
        }
    }
}
