import UIKit

enum AlertButtonStyle {
    case cancel
    case negative
    case positive

    var foregroundColor: UIColor {
        switch self {
        case .cancel:
            UIColor.GrayScale.gray80
        case .negative, .positive:
            UIColor.GrayScale.gray10
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .cancel:
            UIColor.GrayScale.gray30
        case .negative:
            UIColor.Sub.red20
        case .positive:
            UIColor.Primary.blue20
        }
    }
}
