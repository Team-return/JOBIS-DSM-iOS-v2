import UIKit
import Foundation

public extension UIImage {
    static func onboardingImage(_ icon: OnboardingImage) -> UIImage {
        icon.uiImage()
    }
}

public enum OnboardingImage {
    case teamReturnLogo
    case jobisLogo

    func uiImage() -> UIImage {
        let dsImages = DesignSystemAsset.Images.self

        switch self {
        case .teamReturnLogo:
            return dsImages.teamReturnLogo.image

        case .jobisLogo:
            return dsImages.jobisLogo.image
        }
    }
}
