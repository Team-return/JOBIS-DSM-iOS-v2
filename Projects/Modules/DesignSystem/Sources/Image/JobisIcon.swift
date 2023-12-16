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

    func uiImage() -> UIImage {
        let dsIcons = DesignSystemAsset.Icons.self

        switch self {
        case .arrowRight:
            return dsIcons.arrowRight.image
        case .door:
            return dsIcons.door.image
        case .bugBox:
            return dsIcons.bugBox.image
        case .bugReport:
            return dsIcons.bugReport.image
        case .changePassword:
            return dsIcons.changePassword.image
        case .code:
            return dsIcons.code.image
        case .withdrawal:
            return dsIcons.withdrawal.image
        case .logout:
            return dsIcons.logout.image
        }
    }
}
