import UIKit
import Foundation

public extension UIImage {
    static func jobisIcon(_ icon: JobisIcon) -> UIImage {
        icon.uiImage()
    }
}

public enum JobisIcon {
    case arrowRight
    case door

    func uiImage() -> UIImage {
        let dsIcon = DesignSystemAsset.Icons.self

        switch self {
        case .arrowRight:
            return dsIcon.arrowRight.image
        case .door:
            return dsIcon.door.image
        }
    }
}
