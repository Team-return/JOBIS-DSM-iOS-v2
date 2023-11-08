import UIKit
import Foundation

extension UIImage {
    static func jobisIcon(_ icon: JobisIcon) -> UIImage {
        icon.uiImage()
    }
}

enum JobisIcon {
    case arrowRight
    case erorr
    case info
    case success
    case eyeOn
    case eyeOff

    func uiImage() -> UIImage {
        let dsIcon = DesignSystemAsset.Icons.self

        switch self {
        case .arrowRight:
            return dsIcon.arrowRight.image
        case .erorr:
            return dsIcon.error.image
        case .info:
            return dsIcon.info.image
        case .success:
            return dsIcon.success.image
        case .eyeOn:
            return dsIcon.eyeOn.image
        case .eyeOff:
            return dsIcon.eyeOff.image
        }
    }
}
