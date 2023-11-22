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
        }
    }
}
