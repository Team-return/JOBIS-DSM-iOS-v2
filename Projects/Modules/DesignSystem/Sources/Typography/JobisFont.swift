import UIKit

public extension UIFont {
    static func jobisFont(_ font: JobisFontStyle) -> UIFont {
        font.uiFont()
    }
}

extension JobisFontStyle {
    func lineHeight() -> CGFloat {
        switch self {
        case .pageTitle:
            return 36

        case .headLine:
            return 28

        case .subHeadLine, .body:
            return 24

        case .subBody, .description:
            return 20

        case .cation:
            return 16
        }
    }

    func uiFont() -> UIFont {
        let pretendard = DesignSystemFontFamily.Pretendard.self

        switch self {

        case .pageTitle:
            return pretendard.bold.font(size: 24)

        case .headLine:
            return pretendard.semiBold.font(size: 18)

        case .subHeadLine:
            return pretendard.semiBold.font(size: 16)

        case .body:
            return pretendard.medium.font(size: 16)

        case .subBody:
            return pretendard.semiBold.font(size: 14)

        case .description:
            return pretendard.medium.font(size: 14)

        case .cation:
            return pretendard.medium.font(size: 12)
        }
    }

    func size() -> CGFloat {

        switch self {

        case .pageTitle:
            return 24

        case .headLine:
            return 18

        case .subHeadLine, .body:
            return 16

        case .subBody, .description:
            return 14

        case .cation:
            return 12
        }
    }
}
