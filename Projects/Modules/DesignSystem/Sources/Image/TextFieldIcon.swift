import UIKit
import Foundation

extension UIImage {
    static func textFieldIcon(_ icon: TextFieldIcon) -> UIImage {
        icon.uiImage()
    }
}

enum TextFieldIcon {
    case error
    case info
    case success
    case eyeOn
    case eyeOff

    func uiImage() -> UIImage {
        let dsIcon = DesignSystemAsset.Icons.self

        switch self {
        case .error:
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
