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
    case bugBox
    case bugReport
    case changePassword
    case withdrawal
    case logout
    case code
    case bookmarkOn
    case bookmarkOff
    case searchIcon
    case filterIcon

    func uiImage() -> UIImage {
        let dsIcon = DesignSystemAsset.Icons.self

        switch self {
        case .arrowRight:
            return dsIcon.arrowRight.image
        case .door:
            return dsIcon.door.image
        case .bugBox:
            return dsIcon.bugBox.image
        case .bugReport:
            return dsIcon.bugReport.image
        case .changePassword:
            return dsIcon.changePassword.image
        case .code:
            return dsIcon.code.image
        case .withdrawal:
            return dsIcon.withdrawal.image
        case .logout:
            return dsIcon.logout.image
        case .bookmarkOn:
            return dsIcon.bookmarkOn.image
        case .bookmarkOff:
            return dsIcon.bookmarkOff.image
        case .searchIcon:
            return dsIcon.searchIcon.image
        case .filterIcon:
            return dsIcon.filterIcon.image
        }
    }
}
